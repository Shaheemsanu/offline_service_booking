import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:offline_service_booking/src/domain/core/model/booking_model.dart';
import 'package:offline_service_booking/src/infrastructure/booking_repository/booking_repository.dart';

import 'mocks.mocks.dart';

void main() {
  late BookingRepository repository;
  late MockDatabaseServices mockDb;

  setUp(() {
    mockDb = MockDatabaseServices();
    repository = BookingRepository(mockDb);
  });

  group('BookingRepository', () {
    test('getBookings returns list of BookingModel for provider', () async {
      final mockMaps = [
        {
          'id': '1',
          'provider_id': 'p1',
          'user_name': 'Alice',
          'service': 'Cleaning',
          'date': '2025-08-05',
          'time': '10:00',
          'status': 'confirmed',
        },
        {
          'id': '2',
          'provider_id': 'p1',
          'user_name': 'Bob',
          'service': 'Washing',
          'date': '2025-08-05',
          'time': '12:00',
          'status': 'pending',
        },
      ];

      when(
        mockDb.getData(
          tableName: 'bookings',
          where: anyNamed('where'),
          whereArgs: anyNamed('whereArgs'),
        ),
      ).thenAnswer((_) async => mockMaps);

      final result = await repository.getBookings('p1');

      expect(result.length, 2);
      expect(result[0].time, '10:00');
      expect(result[1].date, '2025-08-05');
    });

    test('addBooking calls insertData and returns ID', () async {
      final booking = BookingModel(
        id: '1',
        providerId: 'p1',
        note: 'Charlie',
        date: '2025-08-05',
        time: '10:00',
      );

      when(
        mockDb.insertData(tableName: 'bookings', data: anyNamed('data')),
      ).thenAnswer((_) async => 1);

      final result = await repository.addBooking(booking);

      expect(result, 1);
      verify(
        mockDb.insertData(tableName: 'bookings', data: anyNamed('data')),
      ).called(1);
    });

    test('deleteBooking calls deleteData and returns count', () async {
      when(
        mockDb.deleteData(
          tableName: 'bookings',
          where: anyNamed('where'),
          whereArgs: ['1'],
        ),
      ).thenAnswer((_) async => 1);

      final result = await repository.deleteBooking('1');

      expect(result, 1);
      verify(
        mockDb.deleteData(
          tableName: 'bookings',
          where: 'id = ?',
          whereArgs: ['1'],
        ),
      ).called(1);
    });
  });
}
