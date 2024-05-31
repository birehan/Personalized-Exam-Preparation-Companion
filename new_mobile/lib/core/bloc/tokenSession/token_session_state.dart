part of 'token_session_bloc.dart';

class TokenSessionState extends Equatable {
  const TokenSessionState();

  @override
  List<Object> get props => [];
}

class TokenSessionInitial extends TokenSessionState {}

class TokenSessionExpiredState extends TokenSessionState {}
