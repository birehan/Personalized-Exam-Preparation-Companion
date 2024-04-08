// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../../../../core/core.dart';
// import '../../../features.dart';

// class MockChooseDepartmentPage extends StatefulWidget {
//   const MockChooseDepartmentPage({
//     super.key,
//     required this.departments,
//   });

//   final List<Department> departments;

//   @override
//   State<MockChooseDepartmentPage> createState() =>
//       _MockChooseDepartmentPageState();
// }

// class _MockChooseDepartmentPageState extends State<MockChooseDepartmentPage> {
//   int selectedChipIndex = double.maxFinite.toInt();

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<MockExamBloc, MockExamState>(
//       listener: (context, state) {
//         if (state is GetDepartmentMocksState &&
//             state.status == MockExamStatus.loaded) {
//           context.push(
//             AppRoutes.mockExamsPage,
//             extra: state.departmentMocks,
//           );
//         }
//       },
//       child: selectFieldOfStudy(widget.departments),
//     );
//   }

//   Scaffold selectFieldOfStudy(
//     List<dynamic> chips,
//   ) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
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
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'What Is Your Major Or Field Of Study?',
//               style: GoogleFonts.poppins(
//                 color: const Color(0xFF363636),
//                 fontSize: 24,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Receive relevant materials for university exit exam preparation.',
//               style: GoogleFonts.poppins(
//                 color: const Color(0xFFA3A2B1),
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: Wrap(
//                     spacing: 8,
//                     runSpacing: 12,
//                     children: List.generate(
//                       chips.length,
//                       (index) => CustomChip(
//                         onTap: () {
//                           setState(() {
//                             selectedChipIndex = index;
//                           });
//                           context.read<MockExamBloc>().add(
//                                 GetDepartmentMocksEvent(
//                                   departmentId: chips[index].id,
//                                 ),
//                               );
//                         },
//                         text: chips[index].name,
//                         isSelected: index == selectedChipIndex,
//                       ),
//                     ).toList(),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
