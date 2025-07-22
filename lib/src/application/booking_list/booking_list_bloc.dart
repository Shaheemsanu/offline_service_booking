import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:offline_service_booking/src/application/core/status.dart';
import 'package:offline_service_booking/src/domain/booking/booking.dart';
import 'package:offline_service_booking/src/domain/core/model/booking_model.dart';

part 'booking_list_event.dart';
part 'booking_list_state.dart';

@injectable
class BookingListBloc extends Bloc<BookingListEvent, BookingListState> {
  BookingListBloc(this._bookingRepo) : super(BookingListState()) {
    on<FetchBookingsEvent>(_fetchBookings);
    on<AddBookingEvent>(_addBooking);
    on<DeleteBookingEvent>(_deleteBooking);
    on<ResetBookingStatusEvent>(_restBookingStatus);
  }
  final BookingRepo _bookingRepo;

  FutureOr<void> _fetchBookings(
    FetchBookingsEvent event,
    Emitter<BookingListState> emit,
  ) async {
    try {
      emit(state.copyWith(getBookingStatus: StatusLoading(), bookings: []));

      List<BookingModel> getBookingData = await _bookingRepo.getBookings(
        event.providerId,
      );
      print("getBookingData: $getBookingData");
      if (getBookingData.isNotEmpty) {
        emit(
          state.copyWith(
            bookings: getBookingData,
            getBookingStatus: StatusSuccess(),
          ),
        );
      } else {
        emit(
          state.copyWith(
            getBookingStatus: StatusFailure("Some error occurred"),
          ),
        );
      }
    } on Exception catch (e) {
      emit(state.copyWith(getBookingStatus: StatusFailure(e.toString())));
    }
  }

  FutureOr<void> _addBooking(
    AddBookingEvent event,
    Emitter<BookingListState> emit,
  ) async {
    try {
      emit(state.copyWith(addBookingStatus: StatusLoading()));

      int bookingId = await _bookingRepo.addBooking(event.booking);
      print("bookingId: $bookingId");
      if (bookingId > 0) {
        emit(state.copyWith(addBookingStatus: StatusSuccess()));
      } else {
        emit(
          state.copyWith(
            addBookingStatus: StatusFailure("Some error occurred"),
          ),
        );
      }
    } on Exception catch (e) {
      emit(state.copyWith(addBookingStatus: StatusFailure(e.toString())));
    }
  }

  FutureOr<void> _deleteBooking(
    DeleteBookingEvent event,
    Emitter<BookingListState> emit,
  ) async {
    try {
      emit(state.copyWith(deleteBookingStatus: StatusLoading()));

      int deletedBookingId = await _bookingRepo.deleteBooking(event.bookingId);
      print("deletedBookingId: $deletedBookingId");
      if (deletedBookingId > 0) {
        emit(state.copyWith(deleteBookingStatus: StatusSuccess()));
      } else {
        emit(
          state.copyWith(
            deleteBookingStatus: StatusFailure("Some error occurred"),
          ),
        );
      }
    } on Exception catch (e) {
      emit(state.copyWith(deleteBookingStatus: StatusFailure(e.toString())));
    }
  }

  FutureOr<void> _restBookingStatus(
    ResetBookingStatusEvent event,
    Emitter<BookingListState> emit,
  ) {
    emit(
      state.copyWith(
        deleteBookingStatus: StatusInitial(),
        addBookingStatus: StatusInitial(),
      ),
    );
  }
}
