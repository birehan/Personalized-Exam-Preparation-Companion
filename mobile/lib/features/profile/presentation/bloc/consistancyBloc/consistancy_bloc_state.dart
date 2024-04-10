part of 'consistancy_bloc_bloc.dart';

class ConsistancyBlocState extends Equatable {
  const ConsistancyBlocState();

  @override
  List<Object> get props => [];
}

class ConsistancyBlocInitial extends ConsistancyBlocState {}

class ConsistancyLoadedState extends ConsistancyBlocState {
  final List<List<ConsistencyEntity>> consistencyData;

  const ConsistancyLoadedState({required this.consistencyData});
}

class ConsistancyLoadingState extends ConsistancyBlocState {}

class ConsistancyFailedState extends ConsistancyBlocState {
  final Failure failureType;

  const ConsistancyFailedState({required this.failureType});
}
