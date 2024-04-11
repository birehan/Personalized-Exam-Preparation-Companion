import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class EndofQuestionsResultPage extends StatefulWidget {
  const EndofQuestionsResultPage({
    super.key,
    required this.resultPageParams,
  });

  final ResultPageParams resultPageParams;

  @override
  State<EndofQuestionsResultPage> createState() =>
      _EndofQuestionsResultPageState();
}

class _EndofQuestionsResultPageState extends State<EndofQuestionsResultPage> {
  @override
  Widget build(BuildContext context) {
    return buildResultPageWidget(context);
  }

  Widget buildResultPageWidget(BuildContext context) {
    final Finalwidth = MediaQuery.of(context).size.width;
    final Finalheight = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {},
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/resultBackground.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      context.pop();
                      // for (int index = 0;
                      //     index < resultPageParams.stackHeight;
                      //     index++) {
                      //   context.pop();
                      // }
                      // context.read<PopupMenuBloc>().add(const GoToPageEvent());
                    },
                    child: const XIcon(
                      color: Color(0xFF363636),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            getCompliment(
                                (widget.resultPageParams.score /
                                        widget
                                            .resultPageParams.totalQuestions) *
                                    100,
                                widget.resultPageParams),
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF363636),
                            ),
                          ),
                          SizedBox(
                            width: Finalwidth * 0.8,
                            child: Text(
                              getScoreMessage(
                                  (widget.resultPageParams.score /
                                          widget.resultPageParams
                                              .totalQuestions) *
                                      100,
                                  context),
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF5D5A6F),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Stack(
                            children: [
                              FillingBar(
                                progress: ((widget.resultPageParams.score /
                                        widget
                                            .resultPageParams.totalQuestions) *
                                    100),
                                width: 200,
                                height: 200,
                                strokeWidth: 16,
                              ),
                              Positioned(
                                left: 87,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF1A7A6C),
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 80,
                                left: 87,
                                child: Center(
                                  child: SizedBox(
                                    child: Column(
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            text:
                                                '${((widget.resultPageParams.score / widget.resultPageParams.totalQuestions) * 100).toStringAsFixed(0)}%',
                                            style: GoogleFonts.poppins(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF363636),
                                            ),
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            text:
                                                '${widget.resultPageParams.score} of ${widget.resultPageParams.totalQuestions}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xFF717171),
                                            ),
                                          ),
                                        ),
                                        // Text(
                                        //   '${((resultPageParams.score / resultPageParams.totalQuestions) * 100).toStringAsFixed(0)}%',
                                        //   style: GoogleFonts.poppins(
                                        //     fontSize: 34,
                                        //     fontWeight: FontWeight.w700,
                                        //     color: const Color(0xFF363636),
                                        //   ),
                                        // ),
                                        // Text(
                                        //   '${resultPageParams.score} of ${resultPageParams.totalQuestions}',
                                        //   style: GoogleFonts.poppins(
                                        //     fontSize: 18,
                                        //     fontWeight: FontWeight.w500,
                                        //     color: const Color(0xFF717171),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                left: 53,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  child: FillingStarIcons(
                                    progress: (widget.resultPageParams.score /
                                            widget.resultPageParams
                                                .totalQuestions) *
                                        100,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF18786A),
                            ),
                            onPressed: () {
                              context.pop();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 8,
                              ),
                              width: 40.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/search.png',
                                    width: 24,
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    'Go back',
                                    style: GoogleFonts.poppins(
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
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
