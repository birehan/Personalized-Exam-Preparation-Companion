import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/core.dart';
import '../../../../core/utils/snack_bar.dart';
import '../../../features.dart';

class MyQuizTab extends StatefulWidget {
  const MyQuizTab({
    super.key,
    required this.courseId,
  });

  final String courseId;

  @override
  State<MyQuizTab> createState() => _MyQuizTabState();
}

class _MyQuizTabState extends State<MyQuizTab> {
  @override
  void initState() {
    super.initState();
    context.read<QuizBloc>().add(
          GetUserQuizEvent(
            courseId: widget.courseId,
            isRefreshed: false,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<QuizBloc>().add(
              GetUserQuizEvent(
                courseId: widget.courseId,
                isRefreshed: true,
              ),
            );
      },
      child: MultiBlocListener(
        listeners: [
          BlocListener<QuizBloc, QuizState>(
            listener: (context, state) {
              if (state is GetUserQuizState &&
                  state.status == QuizStatus.error) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(snackBar(state.errorMessage));
              }
            },
          ),
          BlocListener<QuizQuestionBloc, QuizQuestionState>(
            listener: (context, state) {
              if (state is GetQuizByIdState &&
                  state.status == QuizQuestionStatus.error) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(snackBar(state.failure!.errorMessage));
              }
            },
          ),
        ],
        child: BlocBuilder<QuizBloc, QuizState>(
          builder: (context, state) {
            if (state is GetUserQuizState &&
                state.status == QuizStatus.loading) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: ListView.separated(
                  itemCount: 5,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) => _shimmerMyMockCard(),
                ),
              );
            } else if (state is GetUserQuizState &&
                state.status == QuizStatus.loaded) {
              if (state.quizzes!.isEmpty) {
                return EmptyListWidget(
                    message: AppLocalizations.of(context)!.no_quizzes);
                // return Center(
                //   child: Image.asset('assets/images/no_data_image.png'),
                // );
              }
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemCount: state.quizzes!.length,
                      itemBuilder: (context, index) {
                        final quiz = state.quizzes![index];

                        return MyQuizCard(
                          progress:
                              (quiz.score / quiz.questionIds!.length) * 100,
                          courseId: widget.courseId,
                          examId: quiz.id,
                          isMock: false,
                          isCompleted: quiz.isComplete,
                          examName: quiz.name,
                          numberOfQuestions: quiz.questionIds!.length,
                          timeLeft: formatDurationFromQuestions(
                              quiz.questionIds!.length),
                        );
                      },
                    ),
                  ),
                  BlocBuilder<QuizQuestionBloc, QuizQuestionState>(
                    builder: (context, state) {
                      if (state is GetQuizByIdState &&
                          state.status == QuizQuestionStatus.loading) {
                        return Positioned(
                            top: 0,
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              color: Colors.black12,
                              alignment: Alignment.center,
                              child: const CustomProgressIndicator(
                                size: 60,
                              ),
                            ));
                      }
                      return Container();
                    },
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  // Shimmer _quizLoadingShimmer() {
  //   return Shimmer.fromColors(
  //     direction: ShimmerDirection.ttb,
  //     baseColor: const Color.fromARGB(255, 236, 235, 235),
  //     highlightColor: const Color(0xffF9F8F8),
  //     child: Container(
  //       height: 15.h,
  //       margin: EdgeInsets.symmetric(vertical: 1.h),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //     ),
  //   );
  // }

  _shimmerMyMockCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFF6ECEC)),
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: Colors.black.withOpacity(.05),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 130,
                height: 30,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                      height: 10,
                      width: 300,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5))),
                ),
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: ClipOval(
                  child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5))),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                          height: 30,
                          width: 170,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5))),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                              height: 20,
                              width: 90,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                        const SizedBox(width: 12),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                              height: 20,
                              width: 90,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(29))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
