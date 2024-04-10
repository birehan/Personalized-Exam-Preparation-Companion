import 'package:equatable/equatable.dart';

import 'entities.dart';

class SubChapter extends Equatable {
  final String id;
  final String chapterId;
  final String name;
  final List<Content> contents;

  const SubChapter({
    required this.id,
    required this.chapterId,
    required this.name,
    required this.contents,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        contents,
      ];
}
