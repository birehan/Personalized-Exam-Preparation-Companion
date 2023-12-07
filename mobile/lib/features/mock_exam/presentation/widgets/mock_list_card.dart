// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// // import 'package:responsive_sizer/responsive_sizer.dart';

// import '../../../../core/core.dart';
// import '../../../features.dart';

// class MockListCard extends StatelessWidget {
//   const MockListCard({
//     super.key,
//     required this.userMock,
//   });

//   final UserMock userMock;

//   // Future<void> _showOptionsDialog(BuildContext context) async {
//   //   return showDialog<void>(
//   //     context: context,
//   //     builder: (BuildContext context) {
//   //       return AlertDialog(
//   //         title: const Text(
//   //           'Choose an option',
//   //           textAlign: TextAlign.center,
//   //         ),
//   //         content: SingleChildScrollView(
//   //           child: Row(
//   //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //             children: <Widget>[
//   //               GestureDetector(
//   //                 onTap: () {
//   //                   Navigator.of(context).pop();
//   //                 },
//   //                 child: Container(
//   //                   decoration:
//   //                       BoxDecoration(borderRadius: BorderRadius.circular(20)),
//   //                   padding:
//   //                       EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
//   //                   child: const Text(
//   //                     'Analysis',
//   //                     style: TextStyle(color: Color(0xff18786A)),
//   //                   ),
//   //                 ),
//   //               ),
//   //               GestureDetector(
//   //                 onTap: () {
//   //                   Navigator.of(context).pop();
//   //                 },
//   //                 child: Container(
//   //                   decoration:
//   //                       BoxDecoration(borderRadius: BorderRadius.circular(20)),
//   //                   padding:
//   //                       EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
//   //                   child: const Text(
//   //                     'Questions',
//   //                     style: TextStyle(color: Color(0xff18786A)),
//   //                   ),
//   //                 ),
//   //               ),
//   //             ],
//   //           ),
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final progress = (userMock.score / userMock.numberOfQuestions) * 100;
//     final timeTaken = userMock.numberOfQuestions;

//     return BlocListener<MockQuestionBloc, MockQuestionState>(
//       listener: (context, state) {
//         if (state is GetMockExamByIdState &&
//             state.status == MockQuestionStatus.loaded) {
//           context.push(
//             AppRoutes.mockExamQuestionPage,
//             extra: MockExamQuestionWidgetParams(
//               mockType: ,
//               mock: state.mock!,
//               questionMode: !userMock.isCompleted
//                   ? QuestionMode.analysis
//                   : QuestionMode.quiz,
//               // stackHeight: 1,
//             ),
//           );
//         }
//       },
//       child: buildWidget(context, progress, timeTaken),
//     );
//   }

//   InkWell buildWidget(BuildContext context, double progress, int timeTaken) {
//     return InkWell(
//       onTap: () {
//         context.read<MockQuestionBloc>().add(GetMockByIdEvent(id: userMock.id));
//       },
//       child: Row(
//         children: [
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: const Color(0xFFE8E8E8),
//                   width: 1,
//                 ),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 children: [
//                   Stack(
//                     children: [
//                       FillingBar(
//                         progress: progress,
//                         width: 64,
//                         height: 64,
//                         strokeWidth: 6,
//                       ),
//                       Positioned(
//                           top: 36,
//                           left: 36,
//                           child: RichText(
//                             text: TextSpan(
//                               text: '${progress.toInt()}%',
//                               style: GoogleFonts.poppins(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                                 color: const Color(0xFF3A3A3A),
//                               ),
//                             ),
//                           )),
//                     ],
//                   ),
//                   Expanded(
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(right: 12),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   capitalizeFirstLetterOfEachWord(
//                                       userMock.name),
//                                   style: GoogleFonts.poppins(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               CustomChipWidget(
//                                 status: userMock.isCompleted,
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Row(
//                           children: [
//                             Text(
//                               '${userMock.numberOfQuestions} questions',
//                               style: GoogleFonts.poppins(
//                                 fontWeight: FontWeight.w600,
//                                 color: const Color(0xFF848484),
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             Container(
//                               width: 6,
//                               height: 6,
//                               decoration: const BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: Color(0xFF848484),
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             Text(
//                               '$timeTaken mins',
//                               style: GoogleFonts.poppins(
//                                 fontWeight: FontWeight.w600,
//                                 color: const Color(0xFF848484),
//                               ),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
