import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../features.dart';
import '../../../../core/core.dart';

class ExamsPage extends StatelessWidget {
  const ExamsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;

    var examCardParams = <ExamCardParams>[
      ExamCardParams(
        cardBackgroundColor: const Color(0xFFB4F1E8),
        title: AppLocalizations.of(context)!.previous_year_exams,
        description: AppLocalizations.of(context)!.previous_year_exams_text,
        imageAddress: 'assets/images/education.png',
        onPressed: () {
          ChooseMockSubjectPageRoute(isStandard: true).go(context);
        },
      ),
      ExamCardParams(
        cardBackgroundColor: const Color(0xFFE5EFFF),
        title: AppLocalizations.of(context)!.ai_generated_exams,
        description: AppLocalizations.of(context)!.ai_generated_exams_text,
        imageAddress: 'assets/images/chatbot_ai.png',
        onPressed: () {
          ChooseMockSubjectPageRoute(isStandard: false).go(context);
        },
      ),
      ExamCardParams(
        cardBackgroundColor: const Color(0xFFFDF7E5),
        title: AppLocalizations.of(context)!.my_exams,
        description: AppLocalizations.of(context)!.my_exams_text,
        imageAddress: 'assets/images/school_supplies.png',
        onPressed: () {
          MyExamsPageRoute().go(context);
        },
      ),
      ExamCardParams(
        cardBackgroundColor: const Color(0xFFFDF7E5),
        title: 'Downloaded Mocks',
        description: 'Get access to downloaded mocks',
        imageAddress: 'assets/images/school_supplies.png',
        onPressed: () {
          DownloadedMockExamsPageRoute().go(context);
        },
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Mock Exams',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              // Text(
              //   'Explore model exams from different resources',
              //   style: GoogleFonts.poppins(
              //     color: const Color(0xFF4D4B4B),
              //     fontSize: 14,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
              const SizedBox(height: 32),
              ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) => ExamCard(
                  width: width,
                  cardBackgroundColor:
                      examCardParams[index].cardBackgroundColor,
                  title: examCardParams[index].title,
                  description: examCardParams[index].description,
                  imageAddress: examCardParams[index].imageAddress,
                  onPressed: () {
                    examCardParams[index].onPressed();
                  },
                ),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemCount: examCardParams.length,
              ),
              // ExamCard(
              //   width: width,
              //   cardBackgroundColor: const Color(0xFFB4F1E8),
              //   title: AppLocalizations.of(context)!.previous_year_exams,
              //   description:
              //       AppLocalizations.of(context)!.previous_year_exams_text,
              //   imageAddress: 'assets/images/education.png',
              //   onPressed: () {
              //     ChooseMockSubjectPageRoute(isStandard: true).go(context);
              //     // UniversityMockExamPageRoute().go(context);
              //     // context.push(AppRoutes.universityMockExamPage);
              //   },
              // ),
              // const SizedBox(height: 16),
              // ExamCard(
              //   width: width,
              //   cardBackgroundColor: const Color(0xFFE5EFFF),
              //   title: AppLocalizations.of(context)!.ai_generated_exams,
              //   description:
              //       AppLocalizations.of(context)!.ai_generated_exams_text,
              //   imageAddress: 'assets/images/chatbot_ai.png',
              //   onPressed: () {
              //     ChooseMockSubjectPageRoute(isStandard: false).go(context);
              //     // ChooseSubjectPageRoute($extra: true).go(context);
              //     // context.push(AppRoutes.chooseSubjectPage, extra: true);
              //   },
              // ),
              // const SizedBox(height: 16),
              // ExamCard(
              //   width: width,
              //   cardBackgroundColor: const Color(0xFFFDF7E5),
              //   title: AppLocalizations.of(context)!.my_exams,
              //   description: AppLocalizations.of(context)!.my_exams_text,
              //   imageAddress: 'assets/images/school_supplies.png',
              //   onPressed: () {
              //     MyExamsPageRoute().go(context);
              //     // context.push(AppRoutes.myExamPage);
              //   },
              // ),
              // const SizedBox(height: 16),
              // ExamCard(
              //   width: width,
              //   cardBackgroundColor: const Color(0xFFFDF7E5),
              //   title: 'Downloaded Mocks',
              //   description: 'Get access to downloaded mocks',
              //   imageAddress: 'assets/images/school_supplies.png',
              //   onPressed: () {
              //     MyExamsPageRoute().go(context);
              //     // context.push(AppRoutes.myExamPage);
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExamCard extends StatelessWidget {
  const ExamCard({
    super.key,
    required this.width,
    required this.cardBackgroundColor,
    required this.title,
    required this.description,
    required this.imageAddress,
    required this.onPressed,
  });

  final double width;
  final Color cardBackgroundColor;
  final String title;
  final String description;
  final String imageAddress;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              // padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
              decoration: BoxDecoration(
                color: cardBackgroundColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 16,
                    color: Colors.black.withOpacity(0.05),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 0.5 * width),
                          child: Text(
                            description,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF605E5E),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Icon(
                          Icons.arrow_forward,
                          color: Color(0xFFFEA800),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Image.asset(
                      imageAddress,
                      width: 120,
                      height: 120,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
