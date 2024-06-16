import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:prep_genie/core/widgets/noInternet.dart';
import '../../../../core/core.dart';

import '../../../../core/utils/snack_bar.dart';
import '../../../features.dart';

class MockExamsPage extends StatefulWidget {
  const MockExamsPage({
    super.key,
    required this.imageUrl,
    required this.courseName,
    required this.isStandard,
  });

  final String imageUrl;
  final String courseName;
  final bool isStandard;

  @override
  State<MockExamsPage> createState() => _MockExamsPageState();
}

class _MockExamsPageState extends State<MockExamsPage> {
  final TextEditingController _searchController = TextEditingController();

  String departmentId = '';
  @override
  void initState() {
    super.initState();

    final userBloc = context.read<GetUserBloc>().state;

    if (userBloc is GetUserCredentialState) {
      final userCredential = userBloc.userCredential;
      if (userCredential!.departmentId != null &&
          userCredential.departmentId != '') {
        departmentId = userCredential.departmentId!;
      }
      context.read<MockExamBloc>().add(
            GetDepartmentMocksEvent(
              departmentId: departmentId,
              isStandard: widget.isStandard,
              isRefreshed: true,
            ),
          );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          widget.isStandard ? 'University Entrance Exam' : 'AI Generated Exam',
          style: GoogleFonts.poppins(
            color: const Color(0xFF2E2C2C),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF2E2C2C),
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                BlocListener<MockExamBloc, MockExamState>(
                  listener: (context, state) {
                    if (state is GetDepartmentMocksState &&
                        state.status == MockExamStatus.error &&
                        state.failure is RequestOverloadFailure) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(snackBar(state.failure!.errorMessage));
                    }
                  },
                  child: BlocBuilder<MockExamBloc, MockExamState>(
                    builder: (context, state) {
                      if (state is GetDepartmentMocksState &&
                          state.status == MockExamStatus.loading) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: ListView.separated(
                              itemBuilder: (context, index) =>
                                  _shimmerRecommendedCard(),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 12),
                              itemCount: 4,
                            ),
                          ),
                        );
                      } else if (state is GetDepartmentMocksState &&
                          state.status == MockExamStatus.loaded) {
                        final mocks = state.departmentMocks!
                            .where((departmentMock) =>
                                departmentMock.id == widget.courseName)
                            .toList();

                        if (mocks.isEmpty) {
                          return const EmptyListWidget(message: 'No mocks');
                        }

                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: RefreshIndicator(
                              onRefresh: () async {
                                context.read<MockExamBloc>().add(
                                      GetDepartmentMocksEvent(
                                        departmentId: departmentId,
                                        isStandard: widget.isStandard,
                                        isRefreshed: true,
                                      ),
                                    );
                              },
                              child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: mocks[0].mockExams.length,
                                itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: MockCard(
                                    courseName: widget.courseName,
                                    isStandard: widget.isStandard,
                                    imageUrl: widget.imageUrl,
                                    timeCountDown: formatDurationFromQuestions(
                                        mocks[0]
                                            .mockExams[index]
                                            .numberOfQuestions!),
                                    examId: mocks[0].mockExams[index].id,
                                    examTitle: mocks[0].mockExams[index].name,
                                    numberOfQuestions: mocks[0]
                                        .mockExams[index]
                                        .numberOfQuestions!,
                                    examYear:
                                        mocks[0].mockExams[index].examYear!,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      if (state is GetDepartmentMocksState &&
                          state.status == MockExamStatus.error &&
                          state.failure is NetworkFailure) {
                        return NoInternet(
                          reloadCallback: () {
                            context.read<MockExamBloc>().add(
                                  GetDepartmentMocksEvent(
                                    departmentId: departmentId,
                                    isStandard: widget.isStandard,
                                    isRefreshed: true,
                                  ),
                                );
                          },
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ],
            ),
          ),
          BlocBuilder<MockQuestionBloc, MockQuestionState>(
            builder: (context, state) {
              if (state is GetMockExamByIdState &&
                  state.status == MockQuestionStatus.loading) {
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
                  ),
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

//   _shimmerRecommendedCard() {
//     return Shimmer.fromColors(
//       direction: ShimmerDirection.ttb,
//       baseColor: const Color.fromARGB(255, 236, 235, 235),
//       highlightColor: const Color(0xffF9F8F8),
//       child: Container(
//         height: 15.h,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//         ),
//       ),
//     );
//   }
// }

  _shimmerRecommendedCard() {
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
                width: 60,
                height: 60,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: ClipOval(
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5))),
                  ),
                ),
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                    height: 30,
                    width: 110,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5))),
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
                          height: 20,
                          width: 110,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5))),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                              height: 15,
                              width: 90,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: Color(0xFF8A8888),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                              height: 15,
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
                child: ClipOval(
                  child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5))),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
