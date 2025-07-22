part of 'booking_list_bloc.dart';

sealed class BookingListEvent extends Equatable {
  const BookingListEvent();

  @override
  List<Object> get props => [];
}

class FetchBookingsEvent extends BookingListEvent {
  const FetchBookingsEvent({required this.providerId});
  final String providerId;

  @override
  List<Object> get props => [providerId];
}

class AddBookingEvent extends BookingListEvent {
  final BookingModel booking;

  const AddBookingEvent({required this.booking});

  @override
  List<Object> get props => [booking];
}

class DeleteBookingEvent extends BookingListEvent {
  final String bookingId;

  const DeleteBookingEvent({required this.bookingId});

  @override
  List<Object> get props => [bookingId];
}

class ResetBookingStatusEvent extends BookingListEvent {
  const ResetBookingStatusEvent();

  @override
  List<Object> get props => [];
}
