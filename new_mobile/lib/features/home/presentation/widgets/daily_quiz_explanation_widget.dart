import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown_widget/markdown_widget.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/core.dart';
import '../../../features.dart';

class DailyQuizExplanationWidget extends StatelessWidget {
  const DailyQuizExplanationWidget({
    super.key,
    required this.examId,
    required this.question,
    required this.questionMode,
    required this.params,
  });

  final DailyQuizQuestion question;
  final QuestionMode questionMode;
  final String examId;
  final DailyQuestionPageParams params;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 24,
            horizontal: 24,
          ),
          child: Column(
            children: [
              // Text(
              //   question.explanation ?? '',
              //   style: GoogleFonts.poppins(
              //     fontSize: 15,
              //   ),
              // ),
              MarkdownWidget(
                shrinkWrap: true,
                data: question.explanation ?? '',
                config: MarkdownConfig.defaultConfig,
                markdownGenerator: MarkdownGenerator(
                  generators: [latexGenerator],
                  inlineSyntaxList: [LatexSyntax()],
                  richTextBuilder: (span) => Text.rich(
                    span,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              question.relatedTopic != null
                  ? Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          padding: const EdgeInsets.symmetric(
                            vertical: 24,
                            horizontal: 40,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A7A6C),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.related_topic,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Text(
                              //   question.relatedTopic!,
                              //   style: GoogleFonts.poppins(
                              //     color: Colors.white,
                              //     fontSize: 17,
                              //     fontWeight: FontWeight.w500,
                              //   ),
                              //   textAlign: TextAlign.center,
                              // ),
                              MarkdownWidget(
                                shrinkWrap: true,
                                data: question.relatedTopic!,
                                config: MarkdownConfig.defaultConfig,
                                markdownGenerator: MarkdownGenerator(
                                  generators: [latexGenerator],
                                  inlineSyntaxList: [LatexSyntax()],
                                  richTextBuilder: (span) => Text.rich(
                                    span,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              if (question.relatedTopic! !=
                                  'No Related Topic For Now')
                                InkWell(
                                  onTap: () {
                                    context.read<SubChapterBloc>().add(
                                          GetSubChapterContentsEvent(
                                            subChapterId:
                                                question.subChapterId ?? '',
                                          ),
                                        );
                                    context
                                        .read<FetchDailyQuizForAnalysisBloc>()
                                        .add(
                                            FetchDailyQuizForAnalysisInitialEvent());
                                    DailyQuizContentPageRoute(
                                      courseId: question.courseId!,
                                      $extra: params,
                                    ).go(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                      horizontal: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.explore_outlined,
                                          color: Color(0xFF1A7A6C),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          AppLocalizations.of(context)!.explore,
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF1A7A6C),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 0,
                          bottom: 0,
                          child: ClipRect(
                            child: Align(
                              alignment: Alignment.topRight,
                              widthFactor: 0.5,
                              heightFactor: 0.5,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(.15),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: ClipRect(
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              widthFactor: 0.5,
                              heightFactor: 0.5,
                              child: Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(.15),
                                  ),
                                  // color: Colors.white.withOpacity(.15),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: ClipRect(
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              widthFactor: 0.5,
                              heightFactor: 0.5,
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(.15),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          bottom: 0,
                          child: ClipRect(
                            child: Align(
                              alignment: Alignment.topRight,
                              widthFactor: 0.5,
                              heightFactor: 0.5,
                              child: Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(.15),
                                  ),
                                  // color: Colors.white.withOpacity(.15),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}
