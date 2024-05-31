part of 'consistancy_bloc_bloc.dart';

class ConsistancyBlocEvent extends Equatable {
  const ConsistancyBlocEvent();

  @override
  List<Object> get props => [];
}

class GetUserConsistencyDataEvent extends ConsistancyBlocEvent {
  final String year;
  final String? userId;

  const GetUserConsistencyDataEvent({required this.year, this.userId});
}
