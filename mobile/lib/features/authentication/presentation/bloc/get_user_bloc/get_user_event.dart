part of 'get_user_bloc.dart';

abstract class GetUserEvent extends Equatable {
  const GetUserEvent();

  @override
  List<Object> get props => [];
}

class GetUserCredentialEvent extends GetUserEvent {}