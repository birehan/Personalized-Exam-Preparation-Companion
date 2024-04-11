part of 'contest_detail_bloc.dart';

class ContestDetailState extends Equatable {
  const ContestDetailState();

  @override
  List<Object> get props => [];
}

class ContestDetailInitial extends ContestDetailState {}

class ContestDetailLoadedState extends ContestDetailState {
  final ContestDetail contestDetail;

  const ContestDetailLoadedState({required this.contestDetail});
  @override
  List<Object> get props => [contestDetail];
}

class ContestDetailLoadingState extends ContestDetailState {}

class ContestDetailFailedState extends ContestDetailState {
  final Failure failureType;

  const ContestDetailFailedState({required this.failureType});
  @override
  List<Object> get props => [failureType];
}
