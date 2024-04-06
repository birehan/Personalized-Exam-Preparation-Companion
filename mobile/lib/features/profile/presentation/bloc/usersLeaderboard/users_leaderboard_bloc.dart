import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/user_leaderboard_entity.dart';
import 'package:skill_bridge_mobile/features/profile/domain/usecases/get_top_users_usecase.dart';

part 'users_leaderboard_event.dart';
part 'users_leaderboard_state.dart';

class UsersLeaderboardBloc
    extends Bloc<UsersLeaderboardEvent, UsersLeaderboardState> {
  final GetTopUsersUsecase getTopUsersUsecase;
  UsersLeaderboardBloc({required this.getTopUsersUsecase})
      : super(UsersLeaderboardInitial()) {
    on<GetTopUsersEvent>(onGetTopUsersEvent);
  }
  onGetTopUsersEvent(
      GetTopUsersEvent event, Emitter<UsersLeaderboardState> emit) async {
    emit(UsersLeaderboardLoadingState());
    final response = await getTopUsersUsecase(NoParams());
    final state = response.fold(
        (l) => UsersLeaderboardFailedState(
            errorMessage: l.errorMessage, failure: l),
        (r) => UsersLeaderboardLoadedState(topUsers: r));
    emit(state);
  }
}
