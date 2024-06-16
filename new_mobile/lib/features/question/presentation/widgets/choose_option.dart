import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/core.dart';

class ChooseOption extends StatelessWidget {
  const ChooseOption({
    super.key,
    required this.choice,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.questionMode,
    required this.isWrongAnswer,
    required this.isAnswerSelected,
  });

  final String choice;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final QuestionMode questionMode;
  final bool isWrongAnswer;
  final bool isAnswerSelected;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF0072FF)
                : isWrongAnswer
                    ? Colors.red
                    : Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Expanded(
              //   child: RichText(
              //     text: TextSpan(
              //       text: '$label ',
              //       style: GoogleFonts.poppins(
              //         fontSize: 14,
              //         fontWeight: FontWeight.w700,
              //         color: isSelected || isWrongAnswer
              //             ? Colors.white
              //             : const Color(0xFF333333),
              //       ),
              // children: [
              // TextSpan(
              //   text: choice,
              //   style: GoogleFonts.poppins(
              //     fontSize: 14,
              //     fontWeight: FontWeight.w400,
              //     color: isSelected || isWrongAnswer
              //         ? Colors.white
              //         : const Color(0xFF333333),
              //   ),
              // )
              // ],
              //     ),
              //   ),
              // ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    '$label ',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isSelected || isWrongAnswer
                          ? Colors.white
                          : const Color(0xFF333333),
                    ),
                  ),
                  SizedBox(
                    width: 75.w,
                    child: MarkdownWidget(
                      shrinkWrap: true,
                      data: choice,
                      config: MarkdownConfig.defaultConfig,
                      markdownGenerator: MarkdownGenerator(
                        generators: [latexGenerator],
                        inlineSyntaxList: [LatexSyntax()],
                        richTextBuilder: (span) => Text.rich(
                          span,
                          style: GoogleFonts.poppins(
                            color: isSelected || isWrongAnswer
                                ? Colors.white
                                : const Color(0xFF363636),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Row(
              //   children: [
              //     Text(
              //       label,
              //       style: GoogleFonts.poppins(
              //         fontSize: 14,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //     const SizedBox(width: 4),
              // SizedBox(
              //   width: 60.w,
              //   child: TeXView(
              //     // loadingWidgetBuilder: (context) => ,
              //     child: TeXViewMarkdown(
              //       """<p>$choice</p>""",
              //       style: TeXViewStyle(
              //         fontStyle: TeXViewFontStyle(
              //           fontFamily: 'Poppins',
              //           fontSize: 14,
              //           fontWeight: TeXViewFontWeight.w400,
              //         ),
              //         contentColor: const Color(0xFF212121),
              //       ),
              //     ),
              // ),
              //     ),
              //   ],
              // ),
              Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFC9C9C9),
                  ),
                ),
                child: questionMode == QuestionMode.quiz
                    ? null
                    : isSelected
                        ? const Icon(
                            Icons.check,
                            color: Color(0xFF0072FF),
                            size: 14,
                          )
                        : isWrongAnswer
                            ? const Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 14,
                              )
                            : null,
              )
            ],
          ),
        ),
        Positioned.fill(
          child: InkWell(
            onTap: questionMode == QuestionMode.analysis ||
                    (questionMode == QuestionMode.learning && isAnswerSelected)
                ? null
                : onTap,
          ),
        ),
      ],
    );
  }
}
