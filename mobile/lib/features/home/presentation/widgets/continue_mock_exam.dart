// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:shimmer/shimmer.dart';
// import '../../../../core/core.dart';

// import '../../../features.dart';

// class ContinueMockExamWidget extends StatelessWidget {
//   const ContinueMockExamWidget({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return buildWidget(context);
//   }

//   Column buildWidget(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 BlocBuilder<GetUserBloc, GetUserState>(
//                   builder: (context, state) {
//                     if (state is GetUserCredentialState &&
//                         state.status == GetUserStatus.loaded) {
//                       return SizedBox(
//                         width: 90.w,
//                         child: Text(
//                           '${state.userCredential!.department} Mock Exams',
//                           style: GoogleFonts.poppins(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                             color: const Color(0xFF363636),
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       );
//                     }
//                     return const Text('');
//                   },
//                 ),
//                 const SizedBox(height: 4),
//                 SizedBox(
//                   width: 70.w,
//                   child: Text(
//                     'Continue working on the mock exams',
//                     style: GoogleFonts.poppins(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                       color: const Color(0xFF939393),
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         const SizedBox(height: 20),
//         Expanded(
//           child: myMocksWidget(),
//         ),
//       ],
//     );
//   }

//   BlocBuilder<MyMocksBloc, MyMocksState> myMocksWidget() {
//     return BlocBuilder<MyMocksBloc, MyMocksState>(
//       builder: (context, state) {
//         // print(state);
//         if (state is GetMyMocksState && state.status == MyMocksStatus.loaded) {
//           // final incompleteUserMocks = state.userMocks!
//           //     .where((userMock) => userMock.isCompleted == false)
//           //     .toList();

//           if (state.userMocks!.isEmpty) {
//             return const SingleChildScrollView(
//               child: EmptyListWidget(title: 'mocks'),
//             );
//           }

//           return ListView.builder(
//             shrinkWrap: true,
//             itemCount: state.userMocks!.length,
//             itemBuilder: (context, index) => Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8),
//               child: MockListCard(
//                 userMock: state.userMocks![index],
//               ),
//             ),
//           );
//         } else if (state is GetMyMocksState &&
//             state.status == MyMocksStatus.error) {
//           return Center(
//             child: Text(
//               'Failed to load user mocks',
//               style: GoogleFonts.poppins(),
//             ),
//           );
//         }
//         return ListView(
//           shrinkWrap: true,
//           children: List.generate(3, (_) => _courseShimmerCard()),
//         );
//         // return Column(
//         //   children: List.generate(3, (index) => _courseShimmerCard()),
//         // );
//       },
//     );
//   }

//   Shimmer _courseShimmerCard() {
//     return Shimmer.fromColors(
//       direction: ShimmerDirection.ttb,
//       baseColor: const Color.fromARGB(255, 236, 235, 235),
//       highlightColor: const Color(0xffF9F8F8),
//       child: Container(
//         height: 13.h,
//         margin: EdgeInsets.symmetric(vertical: 1.h),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//         ),
//       ),
//     );
//   }
// }
