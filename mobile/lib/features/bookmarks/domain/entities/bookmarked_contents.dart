import 'package:equatable/equatable.dart';

import '../../../chapter/domain/entities/content.dart';

class BookmarkedContent extends Equatable {
  final String id;
  final String userId;
  final Content content;
  final DateTime bookmarkedTime;

  const BookmarkedContent(
      {required this.bookmarkedTime,
      required this.id,
      required this.userId,
      required this.content});

  @override
  // TODO: implement props
  List<Object?> get props => [id, userId, content, bookmarkedTime];
}
