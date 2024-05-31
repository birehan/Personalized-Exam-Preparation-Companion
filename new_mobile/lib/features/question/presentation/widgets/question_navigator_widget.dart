import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionNavigatorWidget extends StatelessWidget {
  final List<String> userAnswers;
  final Function(int) goTo;

  const QuestionNavigatorWidget({
    super.key,
    required this.goTo,
    required this.userAnswers,
  });

  @override
  Widget build(BuildContext context) {
    void _showBottomSheet(BuildContext context) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200,
            color: Colors.white,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text('Take Photo'),
                  onTap: () {
                    // Handle 'Take Photo' action
                    Navigator.pop(context); // Close the bottom sheet
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    // Handle 'Choose from Gallery' action
                    Navigator.pop(context); // Close the bottom sheet
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.cancel),
                  title: const Text('Cancel'),
                  onTap: () {
                    Navigator.pop(context); // Close the bottom sheet
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    return Row(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: userAnswers.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  goTo(index);
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Text(
                    '$index',
                    style: GoogleFonts.poppins(),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 12),
          ),
        ),
        InkWell(
          onTap: () {},
          // child: Icon(Icons.arrot),
        )
      ],
    );
  }
}
