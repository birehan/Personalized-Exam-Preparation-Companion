// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:shimmer/shimmer.dart';

// import '../../../../core/core.dart';
// import '../../../features.dart';

// class MockExamsPage extends StatelessWidget {
//   const MockExamsPage({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<MockQuestionBloc, MockQuestionState>(
//       listener: (context, state) {
//         if (state is GetMockExamByIdState &&
//             state.status == MockQuestionStatus.loaded) {
//           context.push(
//             AppRoutes.mockExamQuestionPage,
//             extra: MockExamQuestionWidgetParams(
//               mock: state.mock!,
//               questionMode: QuestionMode.quiz,
//               // stackHeight: 4,
//             ),
//           );
//         } else if (state is GetMockExamByIdState &&
//             state.status == MockQuestionStatus.error) {
//           const snackBar = SnackBar(content: Text('failed to load'));
//           ScaffoldMessenger.of(context).showSnackBar(snackBar);
//         }
//       },
//       child: Stack(
//         children: [
//           buildMockExamPage(context),
//           BlocBuilder<MockQuestionBloc, MockQuestionState>(
//             builder: (context, state) {
//               if (state is GetMockExamByIdState &&
//                   state.status == MockQuestionStatus.loading) {
//                 return Positioned(
//                   top: 0,
//                   bottom: 0,
//                   left: 0,
//                   right: 0,
//                   child: Container(
//                     color: Colors.black12,
//                     alignment: Alignment.center,
//                     child: const CustomProgressIndicator(),
//                   ),
//                 );
//               }
//               return Container();
//             },
//           )
//         ],
//       ),
//     );
//   }

//   Scaffold buildMockExamPage(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//         leading: InkWell(
//           onTap: () {
//             context.pop();
//           },
//           child: const Icon(
//             Icons.arrow_back,
//             color: Color(0xFF333333),
//             size: 32,
//           ),
//         ),
//         title: Text(
//           'Mock Exams',
//           style: GoogleFonts.poppins(
//             fontSize: 20,
//             fontWeight: FontWeight.w700,
//             color: const Color(0xFF363636),
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(
//           vertical: 8,
//           horizontal: 16,
//         ),
//         child: BlocBuilder<MockExamBloc, MockExamState>(
//           builder: (context, state) {
//             if (state is GetDepartmentMocksState &&
//                 state.status == MockExamStatus.loaded) {
//               List<DepartmentMock> mockExams = state.departmentMocks!;

//               return Container();
//               // return ListView.separated(
//               //   itemBuilder: (context, index) => MockExamCard(
//               //     mockId: mockExams[index].id,
//               //     mockTitle: mockExams[index].name,
//               //     imageUrl: mocks[index % 2]['imageUrl'] as String,
//               //     numQuestions: mockExams[index].numberOfQuestions!,
//               //     timeGiven: mockExams[index].numberOfQuestions!,
//               //     // timeGiven: (mockExams[index].numberOfQuestions! * 1.5).ceil(),
//               //   ),
//               //   separatorBuilder: (context, index) =>
//               //       const SizedBox(height: 16),
//               //   itemCount: mockExams.length,
//               // );
//             } else if (state is GetDepartmentMocksState &&
//                 state.status == MockExamStatus.loading) {
//               return ListView.builder(
//                   itemBuilder: (context, index) => _courseLoadingShimmer(),
//                   itemCount: 4);
//             } else {
//               return Container();
//             }
//           },
//         ),
//       ),
//     );
//   }

//   Shimmer _courseLoadingShimmer() {
//     return Shimmer.fromColors(
//       direction: ShimmerDirection.ltr,
//       baseColor: const Color.fromARGB(255, 236, 235, 235),
//       highlightColor: const Color(0xffF9F8F8),
//       child: Container(
//         height: 10.h,
//         margin: EdgeInsets.symmetric(vertical: 1.h),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//         ),
//       ),
//     );
//   }
// }
