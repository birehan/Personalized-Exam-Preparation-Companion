import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../features.dart';

class MyExamsPage extends StatefulWidget {
  const MyExamsPage({super.key});

  @override
  State<MyExamsPage> createState() => _MyExamsPageState();
}

class _MyExamsPageState extends State<MyExamsPage> {
  @override
  void initState() {
    super.initState();
    context.read<MyMocksBloc>().add(GetMyMocksEvent());
    //! This bloc call is going to be replaced with University and Generated Mocks,
    //! let's leave it like this for now...
    // context.read<QuizBloc>().add(const GetUserQuizEvent(courseId: ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          'My Exams',
          style: GoogleFonts.poppins(
            color: Colors.black,
          ),
        ),
      ),
      body: const MyMocksTab(),
    );
  }
}
