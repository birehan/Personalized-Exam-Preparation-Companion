// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:shimmer/shimmer.dart';

// // import 'package:skill_bridge_mobile/features/course/presentation/bloc/course/course_bloc.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:responsive_sizer/responsive_sizer.dart';

// import '../../../../core/core.dart';
// import '../../../features.dart';

// class HomePage extends StatefulWidget {
//   final VoidCallback navigateToSettings;
//   const HomePage({super.key, required this.navigateToSettings});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     context.read<GetUserBloc>().add(GetUserCredentialEvent());
//     context.read<GetExamDateBloc>().add(ExamDateEvent());
//     // context.read<HomeBloc>().add(GetMyCoursesEvent());
//     context.read<MyMocksBloc>().add(GetMyMocksEvent());
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: () async {
//         context.read<GetUserBloc>().add(GetUserCredentialEvent());
//         context.read<GetExamDateBloc>().add(ExamDateEvent());
//         // context.read<HomeBloc>().add(GetMyCoursesEvent());
//         context.read<MyMocksBloc>().add(GetMyMocksEvent());
//       },
//       child: Stack(
//         children: [
//           Scaffold(
//             body: SingleChildScrollView(
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     BlocBuilder<GetUserBloc, GetUserState>(
//                       builder: (context, state) {
//                         if (state is GetUserCredentialState &&
//                             state.status == GetUserStatus.loaded) {
//                           return HeaderWidget(
//                             name: state.userCredential!.firstName,
//                             imageAddress: state.userCredential!.profileAvatar,
//                             navigateToSettings: widget.navigateToSettings,
//                           );
//                         } else if (state is GetUserCredentialState &&
//                             state.status == GetUserStatus.loading) {
//                           return const ShimmerHeaderWidget();
//                         }
//                         return Container();
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                     BlocBuilder<GetExamDateBloc, GetExamDateState>(
//                       builder: (context, state) {
//                         if (state is ExamDateState &&
//                             state.status == GetExamDateStatus.loaded) {
//                           return CountDownCard(
//                               targetDate: state.targetDate!.date);
//                         } else if (state is ExamDateState &&
//                             state.status == GetExamDateStatus.loading) {
//                           return const ShimmerCountDownCard();
//                         }
//                         return Container();
//                       },
//                     ),
//                     const SizedBox(height: 20),

//                     SearchCourse(
//                       searchController: _searchController,
//                       onTap: () {
//                         context
//                             .read<SearchCourseBloc>()
//                             .add(const UserSearchCourseEvent(query: ''));
//                         context.push(AppRoutes.searchPage);
//                       },
//                     ),
//                     // SizedBox(height: 4.h),
//                     const SizedBox(height: 16),
//                     BlocBuilder<GetUserBloc, GetUserState>(
//                       builder: (context, state) {
//                         if (state is GetUserCredentialState &&
//                             state.status == GetUserStatus.loaded) {
//                           return MockExamWidget(
//                             departmentId: state.userCredential!.departmentId!,
//                           );
//                         }
//                         return const ShimmerCountDownCard();
//                       },
//                     ),
//                     const SizedBox(height: 24),
//                     // const ContinueLearningWidget(),
//                     const ContinueMockExamWidget(),
//                   ],
//                 ),
//               ),
//             ),
//             // bottomNavigationBar: const MyBottomNavigation(
//             //   index: 1,
//             // ),
//           ),
//           BlocBuilder<MockQuestionBloc, MockQuestionState>(
//             builder: (context, state) {
//               if (state is GetMockExamByIdState &&
//                   state.status == MockQuestionStatus.loading) {
//                 return Positioned(
//                     top: 0,
//                     bottom: 0,
//                     left: 0,
//                     right: 0,
//                     child: Container(
//                       color: Colors.black12,
//                       alignment: Alignment.center,
//                       child: const CustomProgressIndicator(
//                         size: 60,
//                       ),
//                     ));
//               }
//               return Container();
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Shimmer _courseLoadingShimmer() {
//     return Shimmer.fromColors(
//       direction: ShimmerDirection.ltr,
//       baseColor: const Color.fromARGB(255, 236, 235, 235),
//       highlightColor: const Color(0xffF9F8F8),
//       child: Column(
//         children: [
//           Container(
//             height: 10.h,
//             margin: EdgeInsets.symmetric(vertical: 1.h),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
