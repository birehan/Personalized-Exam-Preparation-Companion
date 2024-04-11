import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prepgenie/features/authentication/presentation/bloc/get_user_bloc/get_user_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/core.dart';

class SelectSubjectForMockPage extends StatelessWidget {
  const SelectSubjectForMockPage({
    super.key,
    required this.isStandard,
  });

  final bool isStandard;

  @override
  Widget build(BuildContext context) {
    String department = '';
    final userBloc = context.read<GetUserBloc>().state;

    if (userBloc is GetUserCredentialState) {
      final userCredential = userBloc.userCredential;
      if (userCredential!.departmentId != null &&
          userCredential.departmentId != '') {
        department = userCredential.department!;
      }
    }

    final List<Widget> naturaScienceWidgets = [
      SubjectCard(
        subjectTitle: 'Biology',
        imageUrl: 'assets/images/Biology.png',
        // imageUrl:
        //     'https://res.cloudinary.com/djrfgfo08/image/upload/v1697446211/SkillBridge/mobile_team_icons/suatuo9fk4ty5g71o4vu.png',
        isStandard: isStandard,
      ),
      SubjectCard(
        subjectTitle: 'Chemistry',
        imageUrl: 'assets/images/Chemistry.png',
        // imageUrl:
        //     'https://res.cloudinary.com/djrfgfo08/image/upload/v1697446284/SkillBridge/mobile_team_icons/p43wc8hwy6vgq2qfcxe1.png',
        isStandard: isStandard,
      ),
      SubjectCard(
        subjectTitle: 'Physics',
        imageUrl: 'assets/images/Physics.png',
        // imageUrl:
        //     'https://res.cloudinary.com/djrfgfo08/image/upload/v1697446505/SkillBridge/mobile_team_icons/mdzmeqnqjxfftcyyadmx.png',
        isStandard: isStandard,
      ),
      SubjectCard(
        subjectTitle: 'English',
        imageUrl: 'assets/images/English.png',
        // imageUrl:
        //     'https://res.cloudinary.com/djrfgfo08/image/upload/v1697446380/SkillBridge/mobile_team_icons/agdxx77c3jyyfrljsp7x.png',
        isStandard: isStandard,
      ),
      SubjectCard(
        subjectTitle: 'Civics',
        imageUrl: 'assets/images/Civics.png',
        // imageUrl:
        //     'https://res.cloudinary.com/djrfgfo08/image/upload/v1697446324/SkillBridge/mobile_team_icons/za9bhxjbwoqbxuzlhfwt.png',
        isStandard: isStandard,
      ),
      SubjectCard(
        subjectTitle: 'Mathematics',
        imageUrl: 'assets/images/maths.png',
        // imageUrl:
        //     'https://res.cloudinary.com/djrfgfo08/image/upload/v1697446474/SkillBridge/mobile_team_icons/mfyfruoreocx0jtj4snp.png',
        isStandard: isStandard,
      ),
      SubjectCard(
        subjectTitle: 'SAT',
        imageUrl: 'assets/images/SAT.png',
        // imageUrl:
        //     'https://res.cloudinary.com/djrfgfo08/image/upload/v1697446535/SkillBridge/mobile_team_icons/ki9zk3ppga4ixqeux5ks.png',
        isStandard: isStandard,
      ),
    ];

    final List<Widget> socialScienceWidgets = [
      SubjectCard(
        subjectTitle: 'Geography',
        imageUrl: 'assets/images/Geography.png',
        // imageUrl:
        //     'https://res.cloudinary.com/djrfgfo08/image/upload/v1697446423/SkillBridge/mobile_team_icons/uz8fvq8gf0bvdgaxd2ji.png',
        isStandard: isStandard,
      ),
      SubjectCard(
        subjectTitle: 'English',
        imageUrl: 'assets/images/English.png',
        // imageUrl:
        //     'https://res.cloudinary.com/djrfgfo08/image/upload/v1697446380/SkillBridge/mobile_team_icons/agdxx77c3jyyfrljsp7x.png',
        isStandard: isStandard,
      ),
      SubjectCard(
        subjectTitle: 'Civics',
        imageUrl: 'assets/images/Civics.png',
        // imageUrl:
        //     'https://res.cloudinary.com/djrfgfo08/image/upload/v1697446324/SkillBridge/mobile_team_icons/za9bhxjbwoqbxuzlhfwt.png',
        isStandard: isStandard,
      ),
      SubjectCard(
        subjectTitle: 'History',
        imageUrl: 'assets/images/History.png',
        // imageUrl:
        //     'https://res.cloudinary.com/djrfgfo08/image/upload/v1697446453/SkillBridge/mobile_team_icons/oprlfqfrisvjtdbdqvk6.png',
        isStandard: isStandard,
      ),
      SubjectCard(
        subjectTitle: 'Mathematics',
        imageUrl: 'assets/images/maths.png',
        // imageUrl:
        //     'https://res.cloudinary.com/djrfgfo08/image/upload/v1697446474/SkillBridge/mobile_team_icons/mfyfruoreocx0jtj4snp.png',
        isStandard: isStandard,
      ),
      SubjectCard(
        subjectTitle: 'SAT',
        imageUrl: 'assets/images/SAT.png',
        // imageUrl:
        //     'https://res.cloudinary.com/djrfgfo08/image/upload/v1697446535/SkillBridge/mobile_team_icons/ki9zk3ppga4ixqeux5ks.png',
        isStandard: isStandard,
      ),
      SubjectCard(
        subjectTitle: 'Economics',
        imageUrl: 'assets/images/Economics_subject.png',
        // imageUrl:
        //     'https://res.cloudinary.com/djrfgfo08/image/upload/v1697446348/SkillBridge/mobile_team_icons/xtzdkthgs8fxj94yth2d.png',
        isStandard: isStandard,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          AppLocalizations.of(context)!.select_subject,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
        child: GridView.count(
          crossAxisCount: 2,
          children: department == 'Natural Science'
              ? naturaScienceWidgets
              : socialScienceWidgets,
        ),
      ),
    );
  }
}

class SubjectCard extends StatelessWidget {
  const SubjectCard({
    super.key,
    required this.subjectTitle,
    required this.imageUrl,
    required this.isStandard,
  });

  final String subjectTitle;
  final String imageUrl;
  final bool isStandard;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        UniversityMockExamPageRoute(
          courseImage: imageUrl,
          courseName: subjectTitle,
          isStandard: isStandard,
        ).go(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            width: 120,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3F4B49).withOpacity(.07),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Image.asset(
              imageUrl,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subjectTitle,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
