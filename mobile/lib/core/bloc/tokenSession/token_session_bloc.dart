import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'token_session_event.dart';
part 'token_session_state.dart';

class TokenSessionBloc extends Bloc<TokenSessionEvent, TokenSessionState> {
  TokenSessionBloc() : super(TokenSessionInitial()) {
    on<TokenSessionExpiredEvent>((event, emit) {
      emit(TokenSessionExpiredState());
    });
  }
}
