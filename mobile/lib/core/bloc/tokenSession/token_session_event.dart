part of 'token_session_bloc.dart';

class TokenSessionEvent extends Equatable {
  const TokenSessionEvent();

  @override
  List<Object> get props => [];
}

class TokenSessionExpiredEvent extends TokenSessionEvent {}
