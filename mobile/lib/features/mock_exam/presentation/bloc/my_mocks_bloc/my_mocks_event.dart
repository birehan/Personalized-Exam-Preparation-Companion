part of 'my_mocks_bloc.dart';

abstract class MyMocksEvent extends Equatable {
  const MyMocksEvent();

  @override
  List<Object> get props => [];
}

class GetMyMocksEvent extends MyMocksEvent {
  final bool isRefreshed;

  const GetMyMocksEvent({
    required this.isRefreshed,
  });

  @override
  List<Object> get props => [isRefreshed];
}
