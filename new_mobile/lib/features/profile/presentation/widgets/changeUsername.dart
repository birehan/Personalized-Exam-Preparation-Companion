import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/bloc/changeUsernameBloc/username_bloc.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/bloc/changeUsernameBloc/username_event.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/bloc/changeUsernameBloc/username_state.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utils/snack_bar.dart';

class ChangeUsernameDialog extends StatefulWidget {
  const ChangeUsernameDialog({
    super.key,
  });

  @override
  State<ChangeUsernameDialog> createState() => _ChangeUsernameDialogState();
}

class _ChangeUsernameDialogState extends State<ChangeUsernameDialog> {
  final controllerfirstname = TextEditingController();
  final controllerlastname = TextEditingController();
  String firstname = '';
  String lastname = '';
  String errorMessage = '';
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(
          'Change Username',
          style: GoogleFonts.poppins(
            color: const Color(0xFF000000),
            fontSize: 20,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        content: BlocListener<UsernameBloc, UsernameState>(
          listener: (context, state) {
            if (state is UpdateProfileFailedState &&
                state.failureType is RequestOverloadFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(snackBar(state.failureType.errorMessage));
            }
          },
          child: BlocBuilder<UsernameBloc, UsernameState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Enter your new username',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF777777),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                          letterSpacing: -0.02,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    Text(
                      'First Name',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF363636),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        height: 1,
                        letterSpacing: -0.02,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    SizedBox(
                      width: 293, // Width in pixels
                      height: 50,

                      child: TextField(
                        controller: controllerfirstname,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xFFC4C4C4),
                                width: 1), // Border color
                            borderRadius:
                                BorderRadius.circular(8), // Border radius
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 87, 87, 87),
                                width: 1), // Border color
                            borderRadius:
                                BorderRadius.circular(8), // Border radius
                          ),
                          hintText: 'Enter firstname',
                          hintStyle: const TextStyle(
                            color: Color(0xFFA3A3A3),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1,
                            letterSpacing: -0.02, // Change hint text style
                          ),
                        ),
                        onChanged: (value) {
                          firstname = value;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    Text(
                      'Last Name',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF363636),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        height: 1,
                        letterSpacing: -0.02,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    SizedBox(
                      width: 293, // Width in pixels
                      height: 50,

                      child: TextField(
                        controller: controllerlastname,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xFFC4C4C4),
                                width: 1), // Border color
                            borderRadius:
                                BorderRadius.circular(8), // Border radius
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 87, 87, 87),
                                width: 1), // Border color
                            borderRadius:
                                BorderRadius.circular(8), // Border radius
                          ),
                          hintText: 'Enter lastname',
                          hintStyle: const TextStyle(
                            color: Color(0xFFA3A3A3),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1,
                            letterSpacing: -0.02, // Change hint text style
                          ),
                        ),
                        onChanged: (value) {
                          lastname = value;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 38,
                    ),
                    Center(
                      child: Text(
                        errorMessage,
                        style: const TextStyle(
                          color: Color(0xFFFF0000),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    InkWell(
                      onTap: () {
                        print('change usernametapped');
                        if (firstname != '' && lastname != '') {
                          BlocProvider.of<UsernameBloc>(context).add(
                              PostChangeUsername(
                                  firstname: firstname, lastname: lastname));
                          Navigator.pop(context);
                        } else {
                          setState(() {
                            errorMessage =
                                "Please insert correct First Name and Last Name";
                          });
                        }
                      },
                      child: Container(
                          width: 293.0, // Set the width of the container
                          height: 50.0, // Set the height of the container
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  12), // Set the border-radius
                              color: const Color(0xFF1A7A6C)),
                          child: const Center(
                            child: Text(
                              'Reset Username',
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 1,
                              ),
                            ),
                          )),
                    )
                  ],
                ),
              );
            },
          ),
        ));
  }
}
