import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skill_bridge_mobile/core/widgets/noInternet.dart';

import '../../../../core/core.dart';
import '../../../../core/utils/snack_bar.dart';
import '../../../features.dart';

class DownloadedMocksTab extends StatelessWidget {
  const DownloadedMocksTab({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OfflineMockBloc, OfflineMockState>(
          listener: (context, state) {
            if (state is FetchDownloadedMocksFailed &&
                state.failure is RequestOverloadFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(snackBar(state.failure.errorMessage));
            }
          },
        ),
        BlocListener<OfflineMockUserScoreBloc, OfflineMockUserScoreState>(
          listener: (context, state) {
            if (state is OfflineMockUserScoreLoaded) {
              context.read<OfflineMockBloc>().add(FetchDownloadedMockEvent());
            }
          },
        ),
      ],
      child: BlocBuilder<OfflineMockBloc, OfflineMockState>(
        builder: (context, state) {
          if (state is FetchDownloadedMocksLoading) {
            // add
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) => _shimmerMyMockCard(),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemCount: 4,
              ),
            );
          } else if (state is FetchDownloadedMocksFailed) {
            return const Center(
              child: Text('Something went wrong!'),
            );
          } else if (state is FetchDownloadedMocksLoaded) {
            if (state.mocks.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<OfflineMockBloc>().add(
                        FetchDownloadedMockEvent(),
                      );
                },
                child: Center(
                  child: Text(
                    'No downloaded mocks found',
                    style: GoogleFonts.poppins(),
                  ),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<OfflineMockBloc>()
                      .add(FetchDownloadedMockEvent());
                },
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: state.mocks.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final mock = state.mocks[index];
                    final progress = (mock.score / mock.questions.length) * 100;

                    return BlocListener<AlertDialogBloc, AlertDialogState>(
                      listener: (context, state) {
                        if (state is LearningQuizModeState &&
                            state.status == AlertDialogStatus.loaded) {
                          if (mock.isCompleted) {
                            context.read<OfflineMockUserScoreBloc>().add(
                                  OfflineMockUserScoreEvent(
                                    mockId: mock.id,
                                    score: 0,
                                    isCompleted: false,
                                  ),
                                );
                          }
                          DownloadedMockExamQuestionPageRoute(
                            $extra: DownloadedMockExamQuestionPageParams(
                              downloadedUserMock: mock,
                              questionMode: state.questionMode!,
                            ),
                          ).go(context);
                        }
                      },
                      child: MyMockCard(
                        isDownloadedMocks: true,
                        progress: progress,
                        examId: mock.id,
                        isMock: true,
                        isCompleted: mock.isCompleted,
                        examName: mock.name,
                        numberOfQuestions: mock.questions.length,
                        timeLeft:
                            formatDurationFromQuestions(mock.questions.length),
                      ),
                    );
                  },
                ),
              ),
            );
          }
          if (state is FetchDownloadedMocksFailed &&
              state.failure is NetworkFailure) {
            return NoInternet(
              reloadCallback: () {
                //! should be implemented
              },
            );
          }
          return Container();
        },
      ),
    );
  }

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
