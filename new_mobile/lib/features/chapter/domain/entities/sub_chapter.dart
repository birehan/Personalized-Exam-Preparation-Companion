import 'package:equatable/equatable.dart';

import 'entities.dart';

class SubChapter extends Equatable {
  final String id;
  final String chapterId;
  final String name;
  final List<Content> contents;
  final int? order;

  const SubChapter({
    required this.id,
    required this.chapterId,
    required this.name,
    required this.contents,
    this.order,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        contents,
        chapterId,
        order
      ];
}
