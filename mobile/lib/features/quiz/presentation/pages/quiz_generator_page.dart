// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../../../../core/core.dart';
// import '../../../features.dart';

// class QuizGeneratorPageParams extends Equatable {
//   final String courseId;
//   final List<Chapter> chapters;

//   const QuizGeneratorPageParams(
//     this.courseId,
//     this.chapters,
//   );

//   @override
//   List<Object?> get props => [courseId, chapters];
// }

// class QuizGeneratorPage extends StatefulWidget {
//   final QuizGeneratorPageParams quizGeneratorPageParams;

//   const QuizGeneratorPage({
//     super.key,
//     required this.quizGeneratorPageParams,
//   });

//   @override
//   State<QuizGeneratorPage> createState() => _QuizGeneratorPageState();
// }

// class _QuizGeneratorPageState extends State<QuizGeneratorPage> {
//   final _titleController = TextEditingController();
//   final _numberOfQuestionController = TextEditingController();

//   final _formKey = GlobalKey<FormState>();

//   Set<int> chapterSelected = <int>{};

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _numberOfQuestionController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<QuizCreateBloc, QuizCreateState>(
//       listener: (context, state) {
//         if (state is CreateQuizState &&
//             state.status == QuizCreateStatus.loaded) {
//           context
//               .read<QuizQuestionBloc>()
//               .add(GetQuizByIdEvent(quizId: state.quizId!));
//         }
//       },
//       child: BlocListener<QuizQuestionBloc, QuizQuestionState>(
//         listener: (context, state) {
//           if (state is GetQuizByIdState &&
//               state.status == QuizQuestionStatus.loaded) {
//             context.push(
//               AppRoutes.quizExamPage,
//               extra: QuizExamQuestionWidgetParams(
//                 courseId: ,
//                 quizQuestion: state.quizQuestion!,
//                 questionMode: QuestionMode.quiz,
//                 // stackHeight: 2,
//               ),
//             );
//           }
//         },
//         child: Stack(
//           children: [
//             buildWidget(),
//             BlocBuilder<QuizCreateBloc, QuizCreateState>(
//               builder: (context, state) {
//                 if (state is CreateQuizState &&
//                     state.status == QuizCreateStatus.loading) {
//                   return Positioned(
//                       top: 0,
//                       bottom: 0,
//                       left: 0,
//                       right: 0,
//                       child: Container(
//                         alignment: Alignment.center,
//                         color: Colors.black12,
//                         child: const CustomProgressIndicator(),
//                       ));
//                 }
//                 return Container();
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Scaffold buildWidget() {
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
//       ),
//       body: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         'Let\'s create questions based on your preference',
//                         style: GoogleFonts.poppins(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                     // Image.asset(
//                     //   'assets/images/robot.png',
//                     // )
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   'Select Preferred Chapters: Choose at least one',
//                   style: GoogleFonts.poppins(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 BlocBuilder<ChapterBloc, ChapterState>(
//                   builder: (context, state) {
//                     if (state is GetChapterByCourseIdState &&
//                         state.status == ChapterStatus.loaded) {
//                       return Wrap(
//                         children: List.generate(
//                           state.chapters!.length,
//                           (index) => Padding(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 6,
//                               vertical: 3,
//                             ),
//                             child: CustomChip(
//                               text: state.chapters![index].name,
//                               isSelected: chapterSelected.contains(index),
//                               onTap: () {
//                                 if (chapterSelected.contains(index)) {
//                                   setState(() {
//                                     chapterSelected.remove(index);
//                                   });
//                                 } else {
//                                   setState(() {
//                                     chapterSelected.add(index);
//                                   });
//                                 }
//                               },
//                             ),
//                           ),
//                         ),
//                       );
//                     }
//                     return Container();
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'Title Needed',
//                   style: GoogleFonts.poppins(),
//                 ),
//                 TextFormField(
//                   controller: _titleController,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     hintText: 'Enter Quiz Title',
//                   ),
//                   validator: (quizTitle) => validateQuizTitle(quizTitle),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   'Number of Questions',
//                   style: GoogleFonts.poppins(),
//                 ),
//                 TextFormField(
//                   controller: _numberOfQuestionController,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     hintText: 'Enter Number of Questions',
//                   ),
//                   keyboardType: TextInputType.number,
//                   validator: (questionNumber) => validateQuizQuestionsNumber(questionNumber),
//                 ),
//                 const SizedBox(height: 120),
//               ],
//             ),
//           ),
//         ),
//       ),
//       floatingActionButton: InkWell(
//         onTap: chapterSelected.isEmpty
//             ? null
//             : () {
//                 if (_formKey.currentState!.validate()) {
//                   _formKey.currentState!.save();
//                   // Perform further actions with the valid input

//                   context.read<QuizCreateBloc>().add(
//                         CreateQuizEvent(
//                           name: _titleController.text,
//                           chapters: chapterSelected
//                               .map(
//                                 (index) => widget
//                                     .quizGeneratorPageParams.chapters[index].id,
//                               )
//                               .toList(),
//                           courseId: widget.quizGeneratorPageParams.courseId,
//                           numberOfQuestions: int.tryParse(
//                                 _numberOfQuestionController.text,
//                               ) ??
//                               1,
//                         ),
//                       );
//                 }
//               },
//         child: Container(
//           width: MediaQuery.of(context).size.width - 40,
//           height: 50,
//           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
//           decoration: BoxDecoration(
//             color: const Color(0xFF18786A),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Center(
//             child: Text(
//               'Start Quiz',
//               style: GoogleFonts.poppins(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
