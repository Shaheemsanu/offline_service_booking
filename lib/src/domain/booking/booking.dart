import 'package:offline_service_booking/src/domain/core/model/booking_model.dart';

abstract class BookingRepo {
  Future<List<BookingModel>> getBookings(String providerId);
  Future<int> addBooking(BookingModel booking);
  Future<int> deleteBooking(String id);
}
