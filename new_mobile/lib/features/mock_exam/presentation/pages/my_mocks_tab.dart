import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skill_bridge_mobile/core/widgets/noInternet.dart';

import '../../../../core/core.dart';
import '../../../../core/utils/snack_bar.dart';
import '../../../features.dart';

class MyMocksTab extends StatelessWidget {
  const MyMocksTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MyMocksBloc, MyMocksState>(
      listener: (context, state) {
        if (state is GetMyMocksState &&
            state.status == MyMocksStatus.error &&
            state.failure is RequestOverloadFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(snackBar(state.failure!.errorMessage));
        }
      },
      child: BlocBuilder<MyMocksBloc, MyMocksState>(
        builder: (context, state) {
          if (state is GetMyMocksState &&
              state.status == MyMocksStatus.loading) {
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
          } else if (state is GetMyMocksState &&
              state.status == MyMocksStatus.error) {
            return const Center(
              child: Text('Something went wrong!'),
            );
          } else if (state is GetMyMocksState &&
              state.status == MyMocksStatus.loaded) {
            if (state.userMocks!.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<MyMocksBloc>().add(
                        const GetMyMocksEvent(isRefreshed: true),
                      );
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    EmptyListWidget(message: 'No mocks'),
                  ],
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<MyMocksBloc>()
                      .add(const GetMyMocksEvent(isRefreshed: true));
                },
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: state.userMocks!.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final mock = state.userMocks![index];

                    return MyMockCard(
                      progress: (mock.score / mock.numberOfQuestions) * 100,
                      examId: mock.id,
                      isMock: true,
                      isCompleted: mock.isCompleted,
                      examName: mock.name,
                      numberOfQuestions: mock.numberOfQuestions,
                      timeLeft:
                          formatDurationFromQuestions(mock.numberOfQuestions),
                    );
                  },
                ),
              ),
            );
          }
          if (state is GetMyMocksState &&
              state.status == MyMocksStatus.error &&
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

  // _shimmerMyMockCard() {
  //   return Shimmer.fromColors(
  //     direction: ShimmerDirection.ttb,
  //     baseColor: const Color.fromARGB(255, 236, 235, 235),
  //     highlightColor: const Color(0xffF9F8F8),
  //     child: Container(
  //       height: 15.h,
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
