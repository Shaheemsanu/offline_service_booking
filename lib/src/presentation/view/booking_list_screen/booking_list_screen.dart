import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_service_booking/src/application/booking_list/booking_list_bloc.dart';
import 'package:offline_service_booking/src/application/core/status.dart';
import 'package:offline_service_booking/src/domain/core/model/booking_model.dart';
import 'package:offline_service_booking/src/domain/core/model/provider_model.dart';

import 'package:intl/intl.dart';
import 'package:offline_service_booking/src/infrastructure/core/fcm_service/local_notification_service.dart';
import 'package:offline_service_booking/src/presentation/view/widget/delete_button.dart';

class BookingListScreen extends StatefulWidget {
  final ProviderModel provider;

  const BookingListScreen({super.key, required this.provider});

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  @override
  void initState() {
    context.read<BookingListBloc>().add(
      FetchBookingsEvent(providerId: widget.provider.id),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.provider.name} Bookings')),
      body: BlocBuilder<BookingListBloc, BookingListState>(
        buildWhen: (previous, current) {
          // Only rebuild when the bookings list changes
          return previous.getBookingStatus != current.getBookingStatus ||
              previous.bookings != current.bookings;
        },
        builder: (context, state) {
          // addLocalNotification(state.bookings);
          if (state.addBookingStatus is StatusSuccess ||
              state.deleteBookingStatus is StatusSuccess) {
            addRemainder(state);

            context.read<BookingListBloc>().add(ResetBookingStatusEvent());
          }
          print("albooking------------- ${state.bookings.length}");
          return state.bookings.isEmpty
              ? Center(child: Text('No bookings found for this provider.'))
              : ListView.builder(
                  itemCount: state.bookings.length,
                  itemBuilder: (context, index) {
                    final booking = state.bookings[index];

                    return ListTile(
                      leading: Icon(Icons.event_note),
                      title: Text(
                        '${state.bookings[index].date} ${state.bookings[index].time}',
                      ),
                      subtitle: Text(booking.note),
                      trailing: BlocListener<BookingListBloc, BookingListState>(
                        listenWhen: (previous, current) =>
                            previous.deleteBookingStatus !=
                            current.deleteBookingStatus,
                        listener: (context, state) {
                          if (state.deleteBookingStatus == StatusSuccess()) {
                            context.read<BookingListBloc>().add(
                              FetchBookingsEvent(
                                providerId: widget.provider.id,
                              ),
                            );
                          }
                        },
                        child: DeleteButton(
                          onPressed: () {
                            print(
                              "Deleting booking with ID: ${state.bookings[index].id}",
                            );
                            context.read<BookingListBloc>().add(
                              DeleteBookingEvent(bookingId: booking.id),
                            );
                            // deleteBooking(booking.id);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  },
                );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddBookingBottomSheet(
            addBookingFunction: (note, date, time) {
              print(
                "----------Adding booking with note: $note $date $time-------------",
              );
              context.read<BookingListBloc>().add(
                AddBookingEvent(
                  booking: BookingModel(
                    id: "0", // Generate a unique ID
                    providerId: widget.provider.id,
                    date: date,
                    time: time,
                    note: note,
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> addRemainder(BookingListState state) async {
    for (var booking in state.bookings) {
      final dateTime = DateTime.parse('${booking.date} ${booking.time}');
      if (dateTime.isBefore(DateTime.now())) {
        print(
          "Skipping notification for past booking: ${booking.id} at $dateTime",
        ); // Skip past bookings
      } else {
        await LocalNotificationService().scheduleRemainder(
          dateTime: dateTime,
          booking: booking,
          providerModel: widget.provider,
          title:
              "${widget.provider.name} booking reminder at ${booking.date} ${booking.time}",
          body: booking.note,
        );
      }
    }
  }

  void showAddBookingBottomSheet({
    required Function(String note, String date, String time) addBookingFunction,
  }) {
    final noteController = TextEditingController();

    final dateNotifier = ValueNotifier<DateTime?>(null);
    final timeNotifier = ValueNotifier<TimeOfDay?>(null);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: BlocListener<BookingListBloc, BookingListState>(
            listenWhen: (previous, current) =>
                previous.addBookingStatus != current.addBookingStatus,
            listener: (context, state) {
              if (state.addBookingStatus == StatusSuccess()) {
                context.read<BookingListBloc>().add(
                  FetchBookingsEvent(providerId: widget.provider.id),
                );
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add Booking',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                // Note Input
                TextField(
                  controller: noteController,
                  decoration: InputDecoration(labelText: 'Note'),
                ),

                SizedBox(height: 12),

                // Date Picker
                ValueListenableBuilder<DateTime?>(
                  valueListenable: dateNotifier,
                  builder: (context, selectedDate, _) {
                    return ListTile(
                      title: Text(
                        selectedDate == null
                            ? 'Select Date'
                            : 'Date: ${selectedDate.toLocal().toString().split(' ')[0]}',
                      ),
                      trailing: Icon(Icons.calendar_today),
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          dateNotifier.value = picked;
                        }
                      },
                    );
                  },
                ),

                // Time Picker
                ValueListenableBuilder<TimeOfDay?>(
                  valueListenable: timeNotifier,
                  builder: (context, selectedTime, _) {
                    return ListTile(
                      title: Text(
                        selectedTime == null
                            ? 'Select Time'
                            : 'Time: ${selectedTime.format(context)}',
                      ),
                      trailing: Icon(Icons.access_time),
                      onTap: () async {
                        TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null) {
                          timeNotifier.value = picked;
                        }
                      },
                    );
                  },
                ),
                SizedBox(height: 16),

                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    final note = noteController.text;

                    if (note.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter a note')),
                      );
                      return;
                    }

                    if (timeNotifier.value == null ||
                        dateNotifier.value == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please select both date and time'),
                        ),
                      );
                      return;
                    }
                    final formattedDate = DateFormat(
                      'yyyy-MM-dd',
                    ).format(dateNotifier.value!);
                    final formattedTime =
                        '${timeNotifier.value!.hour.toString().padLeft(2, '0')}:${timeNotifier.value!.minute.toString().padLeft(2, '0')}';
                    addBookingFunction(
                      note,
                      formattedDate.toString(),
                      formattedTime,
                    );
                    Navigator.pop(ctx);
                  },
                  child: Text('Add'),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
