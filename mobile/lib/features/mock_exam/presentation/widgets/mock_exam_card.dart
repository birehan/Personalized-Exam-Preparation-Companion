// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import '../../../features.dart';

// class MockExamCard extends StatelessWidget {
//   const MockExamCard({
//     super.key,
//     required this.mockTitle,
//     required this.imageUrl,
//     required this.numQuestions,
//     required this.timeGiven,
//     required this.mockId,
//   });

//   final String mockId;
//   final String mockTitle;
//   final String imageUrl;
//   final int numQuestions;
//   final int timeGiven;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         context.read<MockQuestionBloc>().add(
//               GetMockByIdEvent(
//                 id: mockId,
//               ),
//             );
//         context.read<UserMockBloc>().add(
//               AddMockToUserMockEvent(mockId: mockId),
//             );
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(
//           vertical: 8,
//           horizontal: 8,
//         ),
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: const Color(0xFFE8E8E8),
//             width: 1,
//           ),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           children: [
//             SizedBox(
//               width: 60,
//               child: Image.asset(imageUrl),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     width: 60.w,
//                     child: Text(
//                       mockTitle,
//                       style: GoogleFonts.poppins(
//                         fontSize: 17,
//                         fontWeight: FontWeight.w500,
//                         color: const Color(0xFF363636),
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Text(
//                         '$numQuestions questions',
//                         style: GoogleFonts.poppins(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                           color: const Color(0xFF848484),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Container(
//                         width: 4,
//                         height: 4,
//                         decoration: const BoxDecoration(
//                           color: Color(0xFF848484),
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         '$timeGiven mins',
//                         style: GoogleFonts.poppins(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                           color: const Color(0xFF848484),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
