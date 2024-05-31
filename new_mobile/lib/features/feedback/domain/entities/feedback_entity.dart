import 'package:equatable/equatable.dart';

import '../../../../core/constants/app_enums.dart';

class FeedbackEntity extends Equatable {
  final FeedbackType feedbackType;
  final String id;
  final String message;

  const FeedbackEntity({
    required this.id,
    required this.message,
    required this.feedbackType,
  });

  @override
  List<Object?> get props => [id, message, feedbackType];
}
