import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_router/go_router.dart';

part 'router_event.dart';
part 'router_state.dart';

class RouterBloc extends Bloc<RouterEvent, RouterState> {
  RouterBloc() : super(RouterInitial()) {
    on<PopulateRouterBloc>((event, emit) {
      emit(RouterPopulatedState(router: event.router));
    });
    on<PageChangedEvent>((event, emit) {
      bool makeChatAvailable({required String pageName}) {
        final route = pageName.toLowerCase();
        print('cu route $route');
        if (route.contains('login') ||
            route.contains('signup') ||
            route.contains('content') ||
            route.contains('question') ||
            route.contains('otp') ||
            route.contains('transisitionpage') ||
            route.contains('mockschatpage') ||
            route.contains('endofsubchapter') ||
            route.contains('onboarding') ||
            route.contains('contestquestionbycategory') ||
            route.contains('recommendedmockresult') ||
            route.contains('contest') ||
            route.contains('chat')) {
          return false;
        }
        return true;
      }

      if (state is RouterPopulatedState) {
        emit(RouterPopulatedState(
            router: (state as RouterPopulatedState).router,
            buttonVisibiliy: makeChatAvailable(pageName: event.pageName)));
      }
    });
  }
}
