part of 'member_bloc.dart';

@immutable
abstract class MemberState {}

class MemberInitial extends MemberState {}

class MemberLoading extends MemberState {}

class MemberLoaded extends MemberState {
  final ListMembers listMembers;
  MemberLoaded({required this.listMembers});
}

class MembersFail extends MemberState {
  final String error;
  MembersFail({required this.error});
}

class MemberTokenExpired extends MemberState {}
