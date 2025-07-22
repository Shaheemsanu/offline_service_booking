part of 'booking_list_bloc.dart';

class BookingListState extends Equatable {
  const BookingListState({
    this.bookings = const [],
    this.getBookingStatus = const StatusInitial(),
    this.addBookingStatus = const StatusInitial(),
    this.deleteBookingStatus = const StatusInitial(),
  });
  final List<BookingModel> bookings;
  final Status getBookingStatus;
  final Status addBookingStatus;
  final Status deleteBookingStatus;

  @override
  List<Object> get props => [bookings, getBookingStatus, addBookingStatus, deleteBookingStatus];
  BookingListState copyWith({
    List<BookingModel>? bookings,
    Status? getBookingStatus,
    Status? addBookingStatus,
    Status? deleteBookingStatus,
  }) {
    return BookingListState(
      bookings: bookings ?? this.bookings,
      getBookingStatus: getBookingStatus ?? this.getBookingStatus,
      addBookingStatus: addBookingStatus ?? this.addBookingStatus,
      deleteBookingStatus: deleteBookingStatus ?? this.deleteBookingStatus,
    );
  }
}
