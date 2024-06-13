import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/core.dart';
import '../../../features.dart';

class SelectFieldOfStudyPage extends StatefulWidget {
  const SelectFieldOfStudyPage({
    super.key,
    required this.departments,
  });

  final List<Department> departments;

  @override
  State<SelectFieldOfStudyPage> createState() => _SelectFieldOfStudyPageState();
}

class _SelectFieldOfStudyPageState extends State<SelectFieldOfStudyPage> {
  int selectedChipIndex = double.maxFinite.toInt();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (_, state) {
        if (state is SignupState && state.status == AuthStatus.loaded) {
          context.go(AppRoutes.myhomePage);
        } else if (state is SignupState && state.status == AuthStatus.error) {
          const snackBar = SnackBar(content: Text('signup failed....'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Stack(
        children: [
          selectFieldOfStudy(context),
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is SignupState && state.status == AuthStatus.loading) {
                return Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black12,
                    alignment: Alignment.center,
                    child: const CustomProgressIndicator(),
                  ),
                );
              }
              return Container();
            },
          )
        ],
      ),
    );
  }

  Scaffold selectFieldOfStudy(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            context.pop();
          },
          child: const Icon(
            Icons.arrow_back,
            size: 32,
            color: Color(0xFF363636),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.what_is_your_major_or_field_of_study,
              style: GoogleFonts.poppins(
                color: const Color(0xFF363636),
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.receive_relevant_materials_for_university_exit_exam_preparation,
              style: GoogleFonts.poppins(
                color: const Color(0xFFA3A2B1),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 12,
                    children: List.generate(
                      widget.departments.length,
                      (index) => BlocBuilder<SignupFormBloc, SignupForm>(
                        builder: (context, state) {
                          return CustomChip(
                            onTap: () {
                              setState(
                                () {
                                  selectedChipIndex = index;
                                },
                              );
                            },
                            text: widget.departments[index].name,
                            isSelected: index == selectedChipIndex,
                          );
                        },
                      ),
                    ).toList(),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
