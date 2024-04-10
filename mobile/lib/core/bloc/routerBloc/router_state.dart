part of 'router_bloc.dart';

class RouterState extends Equatable {
  const RouterState();

  @override
  List<Object> get props => [];
}

class RouterInitial extends RouterState {}

class RouterPopulatedState extends RouterState {
  final GoRouter router;
  final bool buttonVisibiliy;

  const RouterPopulatedState({
    required this.router,
    this.buttonVisibiliy = false,
  });
  @override
  List<Object> get props => [router, buttonVisibiliy];
}
