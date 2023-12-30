part of 'confirmride_bloc.dart';

@immutable
abstract class ConfirmrideEvent {}

class DoConfirmRide extends ConfirmrideEvent {
  final dynamic pickuplocation;
  final dynamic droplocation;
  DoConfirmRide({
    required this.droplocation,
    required this.pickuplocation,
  });
}
