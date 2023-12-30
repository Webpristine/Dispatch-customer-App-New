part of 'bookride_bloc.dart';

@immutable
abstract class BookrideEvent {}

class DoBookRide extends BookrideEvent {
  final String bookingid;
  final String vehicleid;
  final String notes;
  final String payment_mode;

  DoBookRide({
    required this.bookingid,
    required this.notes,
    required this.payment_mode,
    required this.vehicleid,
  });
}
