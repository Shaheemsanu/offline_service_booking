import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:offline_service_booking/src/domain/core/model/provider_model.dart';
import 'package:offline_service_booking/src/infrastructure/provider_repository/provider_repository.dart';

import 'mocks.mocks.dart';


void main() {
  late ServiceProviderRepository repository;
  late MockDatabaseServices mockDb;

  setUp(() {
    mockDb = MockDatabaseServices();
    repository = ServiceProviderRepository(mockDb);
  });

  group('ServiceProviderRepository', () {
    test('getProviders returns list of ProviderModel', () async {
      final mockMapList = [
        {
          'id': '1',
          'name': 'John',
          'category': 'AC Repair',
          'contact': '1234567890',
          'location': 'Street 1',
        },
        {
          'id': '2',
          'name': 'Sarah',
          'category': 'Plumbing',
          'contact': '9876543210',
          'location': 'Street 2',
        }
      ];

      when(mockDb.getData(tableName: 'providers')).thenAnswer((_) async => mockMapList);

      final result = await repository.getProviders();

      expect(result.length, 2);
      expect(result[0].name, 'John');
      expect(result[1].category, 'Plumbing');
    });

    test('addProvider calls insertData and returns ID', () async {
      final provider = ProviderModel(
        id: '1',
        name: 'John',
        category: 'AC Repair',
        contact: '1234567890',
        location: 'Some Address',
      );

      when(mockDb.insertData(tableName: 'providers', data: anyNamed('data')))
          .thenAnswer((_) async => 1);

      final result = await repository.addProvider(provider);

      expect(result, 1);
      verify(mockDb.insertData(tableName: 'providers', data: anyNamed('data'))).called(1);
    });

    test('deleteProvider calls deleteData and returns count', () async {
      when(mockDb.deleteData(
        tableName: 'providers',
        where: 'id = ?',
        whereArgs: ['1'],
      )).thenAnswer((_) async => 1);

      final result = await repository.deleteProvider('1');

      expect(result, 1);
      verify(mockDb.deleteData(
        tableName: 'providers',
        where: 'id = ?',
        whereArgs: ['1'],
      )).called(1);
    });
  });
}
