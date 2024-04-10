part of 'router_bloc.dart';

class RouterEvent extends Equatable {
  const RouterEvent();

  @override
  List<Object> get props => [];
}

class PopulateRouterBloc extends RouterEvent {
  final GoRouter router;

  const PopulateRouterBloc({required this.router});
}

class PageChangedEvent extends RouterEvent {
  final String pageName;

  const PageChangedEvent({required this.pageName});
}
