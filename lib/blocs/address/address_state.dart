part of 'address_bloc.dart';

@immutable
abstract class AddressState extends Equatable {}

class AddressInitial extends AddressState {
  @override
  List<Object?> get props => [];
}

class AddressLoading extends AddressState {
  @override
  List<Object?> get props => [];
}

class AddressLoaded extends AddressState {
  final Address address;
  AddressLoaded({required this.address});

  @override
  List<Object?> get props => [address];
}

class AddressNotFound extends AddressState {
  @override
  List<Object?> get props => [];
}

class AddressFailed extends AddressState {
  final String error;
  AddressFailed({required this.error});

  @override
  List<Object?> get props => [error];
}

class TokenExpired extends AddressState {
  @override
  List<Object?> get props => [];
}

class AddAddressSucess extends AddressState {
  @override
  List<Object?> get props => [];
}

class AddAddressFailed extends AddressState {
  @override
  List<Object?> get props => [];
}
