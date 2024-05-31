import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/constants/app_enums.dart';
import '../../../question/domain/entities/question.dart';
import '../bloc/questionVoteBloc/question_vote_bloc.dart';
import 'flag_dialogue_box.dart';

class UserFeedbackWidget extends StatelessWidget {
  const UserFeedbackWidget({
    super.key,
    required this.liked,
    required this.disliked,
    required this.isQuizMode,
    required this.question,
    required this.onLiked,
    required this.onDisliked,
  });

  final bool liked;
  final bool disliked;
  final bool isQuizMode;
  final Question question;
  final Function(bool, bool) onLiked;
  final Function(bool, bool) onDisliked;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            if (liked) {
              onLiked(false, false);
            } else {
              onLiked(true, false);
            }
            context.read<QuestionVoteBloc>().add(QuestionVotedEvent(
                  isLiked: liked,
                  questionId: question.id,
                ));
          },
          icon: Icon(
            Icons.thumb_up_outlined,
            color: liked ? const Color(0xFF18786A) : Colors.black,
          ),
        ),
        // SizedBox(width: 1.w),
        IconButton(
          onPressed: () {
            var originalContext = context;
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return FlagDialog(
                  originalContext: originalContext,
                  id: question.id,
                  feedbackType: FeedbackType.questionFeedback,
                  index: isQuizMode ? 1 : 2,
                );
              },
            );
            onDisliked(false, true);
          },
          icon: Icon(Icons.thumb_down_outlined,
              color: disliked ? const Color(0xFF18786A) : Colors.black),
        )
      ],
    );
  }
}
