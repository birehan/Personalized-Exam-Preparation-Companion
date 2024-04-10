import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/core.dart';

import '../../../features.dart';

class SelectDepartmentPage extends StatefulWidget {
  const SelectDepartmentPage({
    super.key,
  });

  @override
  State<SelectDepartmentPage> createState() => _SelectDepartmentPageState();
}

class _SelectDepartmentPageState extends State<SelectDepartmentPage> {
  int selectedChipIndex = double.maxFinite.toInt();

  @override
  void initState() {
    super.initState();
    context.read<DepartmentBloc>().add(GetDepartmentEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is SignupState && state.status == AuthStatus.loaded) {
          context.go(AppRoutes.home);
        } else if (state is SignupState && state.status == AuthStatus.error) {
          const snackBar = SnackBar(content: Text('signup failed....'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Stack(
        children: [
          buildSelectDepartment(),
          BlocBuilder<DepartmentBloc, DepartmentState>(
            builder: (context, state) {
              if (state is GetDepartmentState &&
                  state.status == GetDepartmentStatus.loading) {
                return Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black12,
                      alignment: Alignment.center,
                      child: const CustomProgressIndicator(),
                    ));
              }
              return Container();
            },
          )
        ],
      ),
    );
  }

  Scaffold buildSelectDepartment() {
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
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: BlocBuilder<SignupFormBloc, SignupForm>(
            //     builder: (context, state) {
            //       return InkWell(
            //         onTap: () {
            //           context.read<AuthenticationBloc>().add(
            //                 SignupEvent(
            //                   userCredential: UserCredential(
            //                     email: state.email,
            //                     firstName: state.firstName,
            //                     lastName: state.lastName,
            //                     password: state.password,
            //                     department: state.department,
            //                     major: state.major,
            //                     otp: state.otp,
            //                   ),
            //                 ),
            //               );
            //         },
            //         child: Text(
            //           'Skip',
            //           style: GoogleFonts.poppins(
            //             color: const Color(0xFF363636),
            //             fontSize: 18,
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            const SizedBox(height: 20),
            Text(
              'What Department Are You Studying?',
              style: GoogleFonts.poppins(
                color: const Color(0xFF363636),
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Receive relevant materials for university exit exam preparation.',
              style: GoogleFonts.poppins(
                color: const Color(0xFFA3A2B1),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            BlocBuilder<DepartmentBloc, DepartmentState>(
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

                                context.read<SignupFormBloc>().add(
                                      ChangeDepartmentEvent(
                                        department: state
                                            .generalDepartments![index].name,
                                      ),
                                    );
                                context.push(AppRoutes.selectFieldOfStudyPage,
                                    extra: state.generalDepartments![index]
                                        .departments);
                              },
                              text: state.generalDepartments![index].name,
                              isSelected: index == selectedChipIndex,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }
}
