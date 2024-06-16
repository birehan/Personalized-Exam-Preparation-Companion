import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/core.dart';

import '../../../../core/utils/snack_bar.dart';
import '../../../features.dart';

class MockChooseGeneralDepartmentPage extends StatefulWidget {
  const MockChooseGeneralDepartmentPage({
    super.key,
  });

  @override
  State<MockChooseGeneralDepartmentPage> createState() =>
      _MockChooseGeneralDepartmentPageState();
}

class _MockChooseGeneralDepartmentPageState
    extends State<MockChooseGeneralDepartmentPage> {
  int selectedChipIndex = double.maxFinite.toInt();

  @override
  Widget build(BuildContext context) {
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
            Text(
              AppLocalizations.of(context)!.what_department_are_you_studying,
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
            BlocListener<DepartmentBloc, DepartmentState>(
              listener: (context, state) {
                if (state is GetDepartmentState) {
                  if (state.status == GetDepartmentStatus.error &&
                      state.failure! is RequestOverloadFailure) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(snackBar(state.failure!.errorMessage));
                  }
                }
              },
              child: BlocBuilder<DepartmentBloc, DepartmentState>(
              builder: (context, state) {
                if (state is GetDepartmentState &&
                    state.status == GetDepartmentStatus.loaded) {
                  return Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 12,
                          children: List.generate(
                            state.generalDepartments!.length,
                            (index) => CustomChip(
                              onTap: () {
                                setState(() {
                                  selectedChipIndex = index;
                                });

                                context.push(
                                  AppRoutes.mockChooseDepartmentPage,
                                  extra: state
                                      .generalDepartments![index].departments,
                                );
                              },
                              text: state.generalDepartments![index].name,
                              isSelected: index == selectedChipIndex,
                            ),
                          ).toList(),
                        ),
                      ),
                    ],
                  );
                }
                return Container();
              },
            )
        )
          ],
        ),
      ),
    );
  }
}
