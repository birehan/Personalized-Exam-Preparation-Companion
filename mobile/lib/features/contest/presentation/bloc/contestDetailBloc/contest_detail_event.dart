part of 'contest_detail_bloc.dart';

class ContestDetailEvent extends Equatable {
  const ContestDetailEvent();

  @override
  List<Object> get props => [];
}

class GetContestdetailEvent extends ContestDetailEvent {
  final String contestId;

  const GetContestdetailEvent({required this.contestId});
}
