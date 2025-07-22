import 'package:injectable/injectable.dart';
import 'package:offline_service_booking/src/domain/booking/booking.dart';
import 'package:offline_service_booking/src/domain/core/model/booking_model.dart';
import 'package:offline_service_booking/src/infrastructure/core/database_service.dart';

@LazySingleton(as: BookingRepo)
class BookingRepository extends BookingRepo {
  BookingRepository(this._db);
  final DatabaseServices _db;

  @override
  Future<List<BookingModel>> getBookings(String providerId) {
    return _db
        .getData(
          tableName: 'bookings',
          where: 'provider_id = ?',
          whereArgs: [providerId],
        )
        .then((maps) {
          List<BookingModel> bookingList = [];
          for (var map in maps) {
            bookingList.add(
              BookingModel.fromMap(
                map.map((key, value) => MapEntry(key, value.toString())),
              ),
            );
          }
          return bookingList;
        });
  }

  @override
  Future<int> addBooking(BookingModel booking) {//provider_id
    return _db.insertData(tableName: 'bookings', data: booking.toMapWithoutId());
  }

  @override
  Future<int> deleteBooking(String id) {
    return _db.deleteData(
      tableName: 'bookings',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
