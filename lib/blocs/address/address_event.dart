part of 'address_bloc.dart';

@immutable
abstract class AddressEvent extends Equatable {}

class FetchAddress extends AddressEvent {
  @override
  List<Object?> get props => [];
}

class InitBloc extends AddressEvent {
  @override
  List<Object?> get props => [];
}

class AddAddress extends AddressEvent {
  final AddressElement element;
  AddAddress({required this.element});
  @override
  List<Object?> get props => [];
}

class RemoveAddress extends AddressEvent {
  final String? element;
  RemoveAddress({required this.element});
  @override
  List<Object?> get props => [];
}

class AddFailedAddress extends AddressEvent {
  @override
  List<Object?> get props => [];
}

class AddSuccessAddress extends AddressEvent {
  @override
  List<Object?> get props => [];
}
