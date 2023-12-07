// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../../../../core/core.dart';
// import '../../../features.dart';

// class MockListPage extends StatelessWidget {
//   const MockListPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // const quizes = [
//     //   {
//     //     'title': 'Mock Exam 1',
//     //     'status': true,
//     //     'questionLength': 100,
//     //     'timeTaken': 20,
//     //     'progress': 79.0,
//     //   },
//     //   {
//     //     'title': 'Mock Exam 2',
//     //     'status': false,
//     //     'questionLength': 15,
//     //     'timeTaken': 20,
//     //     'progress': 0.0,
//     //   },
//     //   {
//     //     'title': 'Mock Exam 3',
//     //     'status': true,
//     //     'questionLength': 15,
//     //     'timeTaken': 20,
//     //     'progress': 99.0,
//     //   },
//     //   {
//     //     'title': 'Mock Exam 4',
//     //     'status': false,
//     //     'questionLength': 15,
//     //     'timeTaken': 20,
//     //     'progress': 0.0,
//     //   },
//     // ];

//     return BlocListener<DepartmentBloc, DepartmentState>(
//       listener: (context, state) {
//         if (state is GetDepartmentState &&
//             state.status == GetDepartmentStatus.loaded) {
//           context.push(AppRoutes.mockChooseGeneralDepartmentPage);
//         } else if (state is GetDepartmentState &&
//             state.status == GetDepartmentStatus.error) {
//           const snackBar = SnackBar(content: Text('mock exam failed....'));
//           ScaffoldMessenger.of(context).showSnackBar(snackBar);
//         }
//       },
//       child: Stack(
//         children: [
//           buildWidget(context),
//           BlocBuilder<DepartmentBloc, DepartmentState>(
//             builder: (context, state) {
//               if (state is GetDepartmentState &&
//                   state.status == GetDepartmentStatus.loading) {
//                 return Positioned(
//                     top: 0,
//                     bottom: 0,
//                     left: 0,
//                     right: 0,
//                     child: Container(
//                       color: Colors.black12,
//                       alignment: Alignment.center,
//                       child: const CustomProgressIndicator(),
//                     ));
//               }
//               return Container();
//             },
//           ),
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
//           ),
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
//           'My Mock Exams',
//           style: GoogleFonts.poppins(
//             fontSize: 20,
//             fontWeight: FontWeight.w700,
//             color: const Color(0xFF363636),
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
//         child: BlocBuilder<MyMocksBloc, MyMocksState>(
//           builder: (context, state) {
//             if (state is GetMyMocksState &&
//                 state.status == MyMocksStatus.loaded) {
//               if (state.userMocks!.isEmpty) {
//                 return Center(
//                     child: Column(
//                   children: [
//                     const Text(
//                       'You have not started any mocks yet.',
//                       style: TextStyle(color: Color(0xff18786A)),
//                     ),
//                     const SizedBox(height: 10),
//                     Image.asset('assets/images/no_data_image.png')
//                   ],
//                 ));
//               }
//               return ListView.separated(
//                 itemBuilder: (context, index) {
//                   return MockListCard(
//                     userMock: state.userMocks![index],
//                   );
//                 },
//                 separatorBuilder: (context, index) =>
//                     const SizedBox(height: 12),
//                 itemCount: state.userMocks!.length,
//               );
//             }
//             return Container();
//           },
//         ),
//       ),
//       // floatingActionButton: ElevatedButton(
//       //   style: ElevatedButton.styleFrom(
//       //     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//       //     foregroundColor: Colors.white,
//       //     backgroundColor: const Color(0xFF18786A),
//       //     shape: RoundedRectangleBorder(
//       //       borderRadius: BorderRadius.circular(24.0),
//       //     ),
//       //   ),
//       //   onPressed: () {
//       //     context.read<DepartmentBloc>().add(GetDepartmentEvent());
//       //   },
//       //   child: Row(
//       //     mainAxisSize: MainAxisSize.min,
//       //     children: [
//       //       const Icon(Icons.add),
//       //       const SizedBox(width: 8),
//       //       Text(
//       //         'New Mock',
//       //         style: GoogleFonts.poppins(
//       //           fontSize: 20,
//       //           fontWeight: FontWeight.w600,
//       //         ),
//       //       ),
//       //     ],
//       //   ),
//       // ),
//     );
//   }
// }
