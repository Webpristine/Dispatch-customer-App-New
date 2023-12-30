part of 'confirmride_bloc.dart';

@immutable
abstract class ConfirmrideState {}

class ConfirmrideInitial extends ConfirmrideState {}

class ConfirmLoading extends ConfirmrideState {}

class ConfirmLoaded extends ConfirmrideState {
  final ConfirmRide confirmRide;
  ConfirmLoaded({
    required this.confirmRide,
  });
}

class ConfirmFail extends ConfirmrideState {
  final String error;
  ConfirmFail({
    required this.error,
  });
}

class TokenExpired extends ConfirmrideState {}
