// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

// import '../../../../core/core.dart';
// import '../../../../features/features.dart';

// class MockExamWidget extends StatelessWidget {
//   const MockExamWidget({
//     super.key,
//     required this.departmentId,
//   });

//   final String departmentId;

//   @override
//   Widget build(BuildContext context) {
//     return mockExamWidget(context);
//     // return BlocListener<MyMocksBloc, MyMocksState>(
//     //   listener: (context, state) {
//     //     if (state is GetMyMocksState && state.status == MyMocksStatus.loaded) {
//     //       context.push(AppRoutes.mockListPage);
//     //     } else if (state is GetMyMocksState &&
//     //         state.status == MyMocksStatus.error) {
//     //       var snackBar = SnackBar(
//     //           content: Text('${state.errorMessage}: failed to load mockexam.'));
//     //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//     //     }
//     //   },
//     //   child: mockExamWidget(context),
//     // );
//   }

//   Widget mockExamWidget(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         // context.read<MyMocksBloc>().add(GetMyMocksEvent());
//         context.read<MockExamBloc>().add(
//               GetDepartmentMocksEvent(departmentId: departmentId),
//             );
//         context.push(AppRoutes.mockExamsPage);
//       },
//       child: Stack(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFE7F0EF),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(
//                             width: 70.w,
//                             child: Text(
//                               'Start New Mock Exams',
//                               style: GoogleFonts.poppins(
//                                 fontSize: 18.sp,
//                                 fontWeight: FontWeight.w600,
//                                 color: const Color(0xFF363636),
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           SizedBox(
//                             width: 70.w,
//                             child: Text(
//                               'Prepare by taking mock exams',
//                               style: GoogleFonts.poppins(
//                                 color: const Color(0xFF949494),
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w400,
//                               ),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Container(
//                         padding: const EdgeInsets.all(6),
//                         decoration: const BoxDecoration(
//                           color: Color(0xFFFEA800),
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Color.fromRGBO(24, 120, 106, 0.35),
//                               offset: Offset(0, 6),
//                               blurRadius: 8,
//                               spreadRadius: 0,
//                             )
//                           ],
//                         ),
//                         child: const Icon(
//                           Icons.play_arrow_rounded,
//                           size: 32,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           // BlocBuilder<MyMocksBloc, MyMocksState>(
//           //   builder: (context, state) {
//           // if (state is GetMyMocksState &&
//           //     state.status == MyMocksStatus.loading) {
//           //       return Positioned(
//           //           top: 0,
//           //           bottom: 0,
//           //           left: 0,
//           //           right: 0,
//           //           child: Container(
//           //             color: Colors.black12,
//           //             alignment: Alignment.center,
//           //             child: const CustomProgressIndicator(),
//           //           ));
//           //     }
//           //     return Container();
//           //   },
//           // )
//         ],
//       ),
//     );
//   }
// }
