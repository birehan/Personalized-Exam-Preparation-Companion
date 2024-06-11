import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class MockDetailPage extends StatefulWidget {
  const MockDetailPage({
    super.key,
    required this.mockId,
    this.courseName,
    this.courseImage,
    this.isStandard,
  });

  final String mockId;
  final String? courseName;
  final String? courseImage;
  final bool? isStandard;

  @override
  State<MockDetailPage> createState() => _MockDetailPageState();
}

class _MockDetailPageState extends State<MockDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<MockDetailBloc>().add(
          GetMockDetailEvent(mockId: widget.mockId),
        );
    context.read<OfflineMockBloc>().add(
          IsMockDownloadedEvent(mockId: widget.mockId),
        );
  }

  @override
  Widget build(BuildContext context) {
    bool isExam = false;

    return BlocListener<AlertDialogBloc, AlertDialogState>(
      listener: (context, state) {
        if (state is LearningQuizModeState &&
            state.status == AlertDialogStatus.loaded) {
          context
              .read<UserMockBloc>()
              .add(AddMockToUserMockEvent(mockId: state.examId!));

          if (state.retake != null && state.retake == true) {
            context
                .read<RetakeMockBloc>()
                .add(RetakeMockEvent(mockId: state.examId!));
          }

          if (widget.courseName != null) {
            UniversityMockExamsQuestionPageRoute(
              mockId: widget.mockId,
              courseImage: widget.courseImage ?? '',
              courseName: widget.courseName ?? '',
              isStandard: widget.isStandard ?? false,
              $extra: MockExamQuestionPageParams(
                  completed: true,
                  questionNumber: state.questionNumber!,
                  mockId: state.examId!,
                  questionMode: state.questionMode!,
                  mockType: MockType.recommendedMocks),
            ).go(context);
          } else {
            MyExamsMockQuestionPageRoute(
                    mockId: state.examId ?? '',
                    $extra: MockExamQuestionPageParams(
                        completed: true,
                        questionNumber: state.questionNumber!,
                        mockId: state.examId!,
                        questionMode: state.questionMode!,
                        mockType: MockType.recommendedMocks))
                .go(context);
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F8F8),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: BlocBuilder<MockDetailBloc, MockDetailState>(
          builder: (context, state) {
            if (state is GetMockDetailLoading) {
              return _mockDetailShimmer();
            } else if (state is GetMockDetailLoaded) {
              final mockDetail = state.mockDetail;
              return Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                image: DecorationImage(
                                  image: Image.asset(
                                    mockImages[mockDetail.subject] ??
                                        mockImages['Maths']!,
                                  ).image,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    // 'Biology University entrance exam',
                                    mockDetail.name,
                                    style: GoogleFonts.poppins(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${mockDetail.examYear} E.C',
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 72),
                          child: mockDetail.userRank == null
                              ? Row(
                                  children: [
                                    MockButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              LearningQuizModeDialog(
                                            examId: mockDetail.id,
                                            questionNumber:
                                                mockDetail.numberOfQuestions,
                                          ),
                                        );
                                      },
                                      iconData: Icons.play_arrow_rounded,
                                      iconColor: Colors.white,
                                      buttonText: 'Start Exam',
                                      bgColor: const Color(0xFF0072FF),
                                      textColor: Colors.white,
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    MockButton(
                                      onPressed: () {
                                        if (widget.courseName != null) {
                                          UniversityMockExamsQuestionPageRoute(
                                            mockId: mockDetail.id,
                                            courseImage:
                                                widget.courseImage ?? '',
                                            courseName: widget.courseName ?? '',
                                            isStandard:
                                                widget.isStandard ?? false,
                                            $extra: MockExamQuestionPageParams(
                                              completed: true,
                                              questionNumber:
                                                  mockDetail.numberOfQuestions,
                                              mockId: mockDetail.id,
                                              questionMode:
                                                  QuestionMode.analysis,
                                              mockType:
                                                  MockType.recommendedMocks,
                                            ),
                                          ).go(context);
                                        } else {
                                          MyExamsMockQuestionPageRoute(
                                            mockId: mockDetail.id,
                                            $extra: MockExamQuestionPageParams(
                                              completed: true,
                                              questionNumber:
                                                  mockDetail.numberOfQuestions,
                                              mockId: mockDetail.id,
                                              questionMode:
                                                  QuestionMode.analysis,
                                              mockType:
                                                  MockType.recommendedMocks,
                                            ),
                                          ).go(context);
                                        }
                                      },
                                      imageUrl: 'assets/images/search.png',
                                      buttonText: 'Mock Analysis',
                                      bgColor: const Color(0xFF0072FF),
                                      textColor: Colors.white,
                                    ),
                                    const SizedBox(width: 8),
                                    MockButton(
                                      elevation: 0,
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              LearningQuizModeDialog(
                                            examId: mockDetail.id,
                                            questionNumber:
                                                mockDetail.numberOfQuestions,
                                            retake: true,
                                          ),
                                        );
                                      },
                                      iconData: Icons.refresh,
                                      iconColor: const Color(0xFF0072FF),
                                      buttonText: 'Retake Exam',
                                      bgColor: Colors.white,
                                      textColor: const Color(0xFF0072FF),
                                    ),
                                  ],
                                ),
                        ),
                        const SizedBox(height: 16),
                        BlocConsumer<OfflineMockBloc, OfflineMockState>(
                          listener: (context, state) {
                            if (state is DownloadMockByIdLoaded) {
                              context.read<OfflineMockBloc>().add(
                                  MarkMockAsDownloadedEvent(
                                      mockId: widget.mockId));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                    'Mock Downloaded Successfully',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor: const Color(0xFF187A6C),
                                ),
                              );
                            }
                            if (state is MarkMockAsDownloadedLoaded) {
                              context.read<OfflineMockBloc>().add(
                                  IsMockDownloadedEvent(mockId: widget.mockId));
                            }
                          },
                          builder: (context, state) {
                            bool isMockDownloaded = false;
                            if (state is IsMockDownloadedLoaded) {
                              isMockDownloaded = state.isMockDownloaded;
                            }
                            return Padding(
                              padding: const EdgeInsets.only(left: 72),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0072FF),
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: isMockDownloaded
                                      ? null
                                      : () {
                                          context.read<OfflineMockBloc>().add(
                                              DownloadMockByIdEvent(
                                                  mockId: widget.mockId));
                                        },
                                  child: Text(
                                    isMockDownloaded
                                        ? 'Downloaded'
                                        : 'Download',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        UserMockRank(
                          isCompleted: mockDetail.userRank != null,
                          numberOfCorrectAnswers: mockDetail.userRank?.score,
                          rank: mockDetail.userRank?.rank,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  MockRanking(
                    mockUserRanks: mockDetail.mockUserRanks,
                    numberOfQuestions: mockDetail.numberOfQuestions,
                  ),
                ],
              );
            }
            return const Center(
              child: Text('failed...'),
            );
          },
        ),
      ),
    );
  }

  Shimmer _mockDetailShimmer() {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ltr,
      baseColor: const Color.fromARGB(255, 236, 235, 235),
      highlightColor: const Color(0xffF9F8F8),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 200,
                            height: 24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 120,
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 72),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 120,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 48,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 60,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 48,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 60,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Top scores',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'RANK',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF7D7D7D),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'NAME',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF7D7D7D),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'SCORE',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF7D7D7D),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        8,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Container(
                                width: 20,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
