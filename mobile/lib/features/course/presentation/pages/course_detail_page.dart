// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:shimmer/shimmer.dart';
// import '../../../../core/core.dart';
// import '../../../features.dart';

// class CourseDetailPage extends StatefulWidget {
//   const CourseDetailPage({super.key});

//   @override
//   State<CourseDetailPage> createState() => _CourseDetailPageState();
// }

// class _CourseDetailPageState extends State<CourseDetailPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: 5.h,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//         leading: Padding(
//           padding: EdgeInsets.only(top: 1.h),
//           child: IconButton(
//             icon: const Icon(Icons.arrow_back),
//             color: Colors.black,
//             onPressed: () {
//               context.pop();
//             },
//           ),
//         ),
//         title: Padding(
//           padding: EdgeInsets.only(top: 1.h),
//           child: BlocBuilder<CourseWithUserAnalysisBloc,
//               CourseWithUserAnalysisState>(
//             builder: (context, state) {
//               if (state is CourseLoadedState) {
//                 return Text(
//                   state.userCourseAnalysis.course.name,
//                   style: const TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 );
//               }
//               return const Text('');
//             },
//           ),
//         ),
//       ),
//       body:
//           BlocBuilder<CourseWithUserAnalysisBloc, CourseWithUserAnalysisState>(
//               builder: (context, state) {
//         if (state is CourseErrorState) {
//           return Center(
//             child: Text(state.message),
//           );
//         } else if (state is CourseLoadedState) {
//           Course course = state.userCourseAnalysis.course;
//           List<UserChapterAnalysis> userChapterAnalysis =
//               state.userCourseAnalysis.userChaptersAnalysis;

//           ImageProvider? imageProvider;
//           course.image != null && course.image!.imageAddress != null
//               ? imageProvider = NetworkImage(course.image!.imageAddress!)
//               : imageProvider = const AssetImage(courseDefaultImageAddress);
//           // return _courseDetailLoadingShimmer();
//           return Padding(
//             padding: EdgeInsets.only(top: 2.h, left: 5.w, right: 5.w),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(20),
//                           child: Image(
//                             fit: BoxFit.cover,
//                             height: 30.h,
//                             image: imageProvider,
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                   SizedBox(height: 2.5.h),
//                   const Text(
//                     'Description',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.w500,
//                       fontSize: 20,
//                     ),
//                   ),
//                   SizedBox(height: 2.5.h),
//                   Text(
//                     course.description,
//                     style: TextStyle(
//                       height: 1.3,
//                       fontSize: 16.sp,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   SizedBox(height: 3.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         'Chapters',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w500, fontSize: 20),
//                       ),
//                       Text(
//                         '${course.numberOfChapters} chapters',
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w400,
//                           fontSize: 18,
//                         ),
//                       )
//                     ],
//                   ),
//                   SizedBox(
//                     height: 2.h,
//                   ),
//                   ListView(
//                       physics: const NeverScrollableScrollPhysics(),
//                       shrinkWrap: true,
//                       children: userChapterAnalysis.map((userChapterAnalysis) {
//                         return ChaptersCard(
//                           userChapterAnalysis: userChapterAnalysis,
//                         );
//                       }).toList())
//                 ],
//               ),
//             ),
//           );
//         }
//         return _courseDetailLoadingShimmer();
//       }),
//     );
//   }

//   Shimmer _courseDetailLoadingShimmer() {
//     return Shimmer.fromColors(
//       direction: ShimmerDirection.ltr,
//       baseColor: const Color.fromARGB(255, 236, 235, 235),
//       highlightColor: const Color(0xffF9F8F8),
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 2.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 3.h),
//             Container(
//               height: 25.h,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//             SizedBox(height: 2.h),
//             Container(
//               height: 3.h,
//               width: 28.w,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             SizedBox(height: 1.h),
//             Container(
//               height: 20.h,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//             SizedBox(height: 2.h),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   height: 3.h,
//                   width: 35.w,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 Container(
//                   height: 3.h,
//                   width: 25.w,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ],
//             ),
//             Container(
//               height: 15.h,
//               margin: EdgeInsets.symmetric(vertical: 1.h),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//             Container(
//               height: 15.h,
//               margin: EdgeInsets.symmetric(vertical: 1.h),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
