part of 'add_content_bookmark_bloc_bloc.dart';

class AddContentBookmarkBlocState extends Equatable {
  const AddContentBookmarkBlocState();

  @override
  List<Object> get props => [];
}

class AddContentBookmarkBlocInitial extends AddContentBookmarkBlocState {}

class ContentBookmarkAddedState extends AddContentBookmarkBlocState {}

class ContentBookmarkAddingState extends AddContentBookmarkBlocState {}

class ContentBookmarkErrorState extends AddContentBookmarkBlocState {
  final Failure failure;
  const ContentBookmarkErrorState({required this.failure});
}
