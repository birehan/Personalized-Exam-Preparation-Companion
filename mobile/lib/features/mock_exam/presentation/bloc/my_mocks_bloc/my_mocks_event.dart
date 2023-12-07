part of 'my_mocks_bloc.dart';

abstract class MyMocksEvent extends Equatable {
  const MyMocksEvent();

  @override
  List<Object> get props => [];
}

class GetMyMocksEvent extends MyMocksEvent {}
