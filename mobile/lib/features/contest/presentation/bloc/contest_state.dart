part of 'contest_bloc.dart';

abstract class ContestState extends Equatable {
  const ContestState();  

  @override
  List<Object> get props => [];
}
class ContestInitial extends ContestState {}
