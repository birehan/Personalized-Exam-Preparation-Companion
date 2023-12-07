// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:shimmer/shimmer.dart';

// import '../../../../core/core.dart';
// import '../../../features.dart';

// class QuizListPage extends StatefulWidget {
//   const QuizListPage({
//     Key? key,
//     required this.course,
//   }) : super(key: key);

//   final Course course;

//   @override
//   State<QuizListPage> createState() => _QuizListPageState();
// }

// class _QuizListPageState extends State<QuizListPage> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<QuizBloc>().add(
//           const GetUserQuizEvent(courseId: ''),
//         );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<ChapterBloc, ChapterState>(
//       listener: (context, state) {
//         if (state is GetChapterByCourseIdState &&
//             state.status == ChapterStatus.loaded) {
//           context.push(
//             AppRoutes.quizGeneratorPage,
//             extra: QuizGeneratorPageParams(
//               widget.course.id,
//               state.chapters!,
//             ),
//           );
//         }
//       },
//       child: Stack(
//         children: [
//           buildWidget(context),
//           BlocBuilder<ChapterBloc, ChapterState>(
//             builder: (context, state) {
//               if (state is GetChapterByCourseIdState &&
//                   state.status == ChapterStatus.loading) {
//                 return Positioned(
//                     top: 0,
//                     bottom: 0,
//                     left: 0,
//                     right: 0,
//                     child: Container(
//                       alignment: Alignment.center,
//                       color: Colors.black12,
//                       child: const CustomProgressIndicator(),
//                     ));
//               }
//               return Container();
//             },
//           ),
//           BlocBuilder<QuizQuestionBloc, QuizQuestionState>(
//             builder: (context, state) {
//               if (state is GetQuizByIdState &&
//                   state.status == QuizQuestionStatus.loading) {
//                 return Positioned(
//                     top: 0,
//                     bottom: 0,
//                     left: 0,
//                     right: 0,
//                     child: Container(
//                       alignment: Alignment.center,
//                       color: Colors.black12,
//                       child: const CustomProgressIndicator(),
//                     ));
//               }
//               return Container();
//             },
//           )
//         ],
//       ),
//     );
//   }

//   Scaffold buildWidget(BuildContext context) {
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
//             size: 32,
//             color: Color(0xFF363636),
//           ),
//         ),
//         title: Text(
//           'My Quizzes',
//           style: GoogleFonts.poppins(
//             fontSize: 20,
//             fontWeight: FontWeight.w700,
//             color: const Color(0xFF363636),
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
//         child: BlocBuilder<QuizBloc, QuizState>(
//           builder: (context, state) {
//             if (state is GetUserQuizState &&
//                 state.status == QuizStatus.loaded) {
//               if (state.quizzes!.isEmpty) {
//                 return Center(
//                     child: Column(
//                   children: [
//                     const Text(
//                       'You have not started any quizes yet.',
//                       style: TextStyle(color: Color(0xff18786A)),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     Image.asset('assets/images/no_data_image.png')
//                   ],
//                 ));
//               }
//               return ListView.separated(
//                 itemBuilder: (context, index) {
//                   return QuizListCard(
//                     quizId: state.quizzes![index].id,
//                     title: state.quizzes![index].name,
//                     status: state.quizzes![index].isComplete,
//                     questionLength: state.quizzes![index].questionIds!.length,
//                     timeTaken: state.quizzes![index].questionIds!.length,
//                     progress: (state.quizzes![index].score /
//                             state.quizzes![index].questionIds!.length) *
//                         100,
//                   );
//                 },
//                 separatorBuilder: (context, index) =>
//                     const SizedBox(height: 12),
//                 itemCount: state.quizzes!.length,
//               );
//             } else if (state is GetUserQuizState &&
//                 state.status == QuizStatus.loading) {
//               return ListView.builder(
//                 itemCount: 4,
//                 itemBuilder: (context, index) => _myQuizesLoadingShimmer(),
//               );
//             } else if (state is GetUserQuizState &&
//                 state.status == QuizStatus.loading) {
//               return Text('${state.errorMessage} failed to load quizes');
//             }
//             return Container();
//           },
//         ),
//       ),
//       floatingActionButton: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//           foregroundColor: Colors.white,
//           backgroundColor: const Color(0xFF18786A),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(24.0),
//           ),
//         ),
//         onPressed: () {
//           context.read<ChapterBloc>().add(
//                 GetChapterByCourseIdEvent(
//                   courseId: widget.course.id,
//                 ),
//               );
//         },
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.add),
//             const SizedBox(width: 8),
//             Text(
//               'New Quiz',
//               style: GoogleFonts.poppins(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Shimmer _myQuizesLoadingShimmer() {
//     return Shimmer.fromColors(
//       direction: ShimmerDirection.ttb,
//       baseColor: const Color.fromARGB(255, 236, 235, 235),
//       highlightColor: const Color(0xffF9F8F8),
//       child: Container(
//         height: 12.h,
//         margin: EdgeInsets.symmetric(vertical: 1.h),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//         ),
//       ),
//     );
//   }
// }
