import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_service_booking/src/application/booking_list/booking_list_bloc.dart';
import 'package:offline_service_booking/src/application/core/status.dart';
import 'package:offline_service_booking/src/domain/booking/booking.dart';
import 'package:offline_service_booking/src/domain/core/model/booking_model.dart';

class MockBookingRepo extends Mock implements BookingRepo {}

void main() {
  late BookingListBloc bloc;
  late MockBookingRepo mockBookingRepo;

  final booking = BookingModel(
    id: '1',
    providerId: 'p1',
    note: 'Charlie',
    date: '2025-08-05',
    time: '10:00',
  );

  setUp(() {
    mockBookingRepo = MockBookingRepo();
    bloc = BookingListBloc(mockBookingRepo);
  });

  group('FetchBookingsEvent', () {
    test(
      'emits [Loading, Success] when bookings fetched successfully',
      () async {
        when(
          () => mockBookingRepo.getBookings('p1'),
        ).thenAnswer((_) async => [booking]);

        expectLater(
          bloc.stream,
          emitsInOrder([
            predicate<BookingListState>(
              (s) => s.getBookingStatus is StatusLoading,
            ),
            predicate<BookingListState>(
              (s) =>
                  s.getBookingStatus is StatusSuccess &&
                  s.bookings.contains(booking),
            ),
          ]),
        );

        bloc.add(FetchBookingsEvent(providerId: 'p1'));
      },
    );

    test('emits [Loading, Failure] when fetching bookings fails', () async {
      when(
        () => mockBookingRepo.getBookings('p1'),
      ).thenThrow(Exception('Failed'));

      expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<BookingListState>(
            (s) => s.getBookingStatus is StatusLoading,
          ),
          predicate<BookingListState>(
            (s) => s.getBookingStatus is StatusFailure,
          ),
        ]),
      );
      bloc.add(FetchBookingsEvent(providerId: 'p1'));
    });
  });

  group('AddBookingEvent', () {
    test('emits [Loading, Success] when booking added', () async {
      when(
        () => mockBookingRepo.addBooking(booking),
      ).thenAnswer((_) async => 1);

      expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<BookingListState>(
            (s) => s.addBookingStatus is StatusLoading,
          ),
          predicate<BookingListState>(
            (s) => s.addBookingStatus is StatusSuccess,
          ),
        ]),
      );

      bloc.add(AddBookingEvent(booking: booking));
    });

    test('emits [Loading, Failure] when booking fails to add', () async {
      when(
        () => mockBookingRepo.addBooking(booking),
      ).thenAnswer((_) async => 0);

      expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<BookingListState>(
            (s) => s.addBookingStatus is StatusLoading,
          ),
          predicate<BookingListState>(
            (s) => s.addBookingStatus is StatusFailure,
          ),
        ]),
      );

      bloc.add(AddBookingEvent(booking: booking));
    });
  });

  group('DeleteBookingEvent', () {
    test('emits [Loading, Success] when booking deleted', () async {
      when(() => mockBookingRepo.deleteBooking('1')).thenAnswer((_) async => 1);

      expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<BookingListState>(
            (s) => s.deleteBookingStatus is StatusLoading,
          ),
          predicate<BookingListState>(
            (s) => s.deleteBookingStatus is StatusSuccess,
          ),
        ]),
      );

      bloc.add(DeleteBookingEvent(bookingId: '1'));
    });

    test('emits [Loading, Failure] when deletion fails', () async {
      when(() => mockBookingRepo.deleteBooking('1')).thenAnswer((_) async => 0);

      expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<BookingListState>(
            (s) => s.deleteBookingStatus is StatusLoading,
          ),
          predicate<BookingListState>(
            (s) => s.deleteBookingStatus is StatusFailure,
          ),
        ]),
      );

      bloc.add(DeleteBookingEvent(bookingId: '1'));
    });
  });

  test(
    'ResetBookingStatusEvent resets add and delete status to initial',
    () async {
      bloc.emit(
        bloc.state.copyWith(
          addBookingStatus: StatusSuccess(),
          deleteBookingStatus: StatusFailure("Error"),
        ),
      );

      bloc.add(ResetBookingStatusEvent());
    },
  );
}
