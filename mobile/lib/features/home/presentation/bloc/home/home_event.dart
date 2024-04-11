part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetMyCoursesEvent extends HomeEvent {}

class GetHomeEvent extends HomeEvent {
  final bool refresh;

  const GetHomeEvent({required this.refresh});
}
