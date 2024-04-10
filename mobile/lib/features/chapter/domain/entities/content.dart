import 'package:equatable/equatable.dart';

class Content extends Equatable {
  final String id;
  final String subChapterId;
  final String title;
  final String content;
  final bool isBookmarked;

  const Content(
      {required this.id,
      required this.subChapterId,
      required this.title,
      required this.content,
      required this.isBookmarked});

  @override
  List<Object?> get props => [
        id,
        subChapterId,
        title,
        content,
      ];
}
