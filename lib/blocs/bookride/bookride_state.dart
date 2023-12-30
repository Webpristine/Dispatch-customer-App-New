part of 'bookride_bloc.dart';

@immutable
abstract class BookrideState {}

class BookrideInitial extends BookrideState {}

class BookRideLoading extends BookrideState {}

class BookRideLoaded extends BookrideState {
  final BookRide bookRide;
  BookRideLoaded({
    required this.bookRide,
  });
}

class BookRideFail extends BookrideState {
  final String error;
  BookRideFail({
    required this.error,
  });
}

class TokenExpired extends BookrideState {}
