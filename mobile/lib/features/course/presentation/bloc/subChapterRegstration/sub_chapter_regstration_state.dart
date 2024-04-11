part of 'sub_chapter_regstration_bloc.dart';

abstract class SubChapterRegstrationState extends Equatable {
  const SubChapterRegstrationState();

  @override
  List<Object> get props => [];
}

class SubChapterRegstrationInitial extends SubChapterRegstrationState {}

class SubChapterRegstrationFailedState extends SubChapterRegstrationState {}

class SubChapterRegstrationSuccessState extends SubChapterRegstrationState {}

class SubChapterRegstrationLoadingState extends SubChapterRegstrationState {}
