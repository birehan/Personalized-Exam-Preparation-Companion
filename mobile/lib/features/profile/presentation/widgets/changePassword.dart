import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/bloc/changePasswordBloc/password_bloc.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/bloc/changePasswordBloc/password_event.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/bloc/changePasswordBloc/password_state.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({
    super.key,
  });

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final controllerold = TextEditingController();
  final controllernew = TextEditingController();
  final controllerrepeat = TextEditingController();
  String oldPassword = '';
  String newPassword = '';
  String repeatPassword = '';
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        // backgroundColor: Colors.white, 
        title: Text(
          'Change Password',
          style: GoogleFonts.poppins(
            color: Color(0xFF000000),
            fontSize: 20,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        content: BlocBuilder<PasswordBloc, PasswordState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New password must differ from old ones.',
                    style: GoogleFonts.poppins(
                      color: Color(0xFF777777),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                      letterSpacing: -0.02,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 39,
                  ),
                  Text(
                    'Old Password',
                    style: GoogleFonts.poppins(
                      color: Color(0xFF363636),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 1,
                      letterSpacing: -0.02,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  Container(
                    width: 293, // Width in pixels
                    height: 50,

                    child: TextField(
                      controller: controllerold,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(0xFFC4C4C4),
                              width: 1), // Border color
                          borderRadius:
                              BorderRadius.circular(8), // Border radius
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 87, 87, 87),
                              width: 1), // Border color
                          borderRadius:
                              BorderRadius.circular(8), // Border radius
                        ),
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(
                          color: Color(0xFFA3A3A3),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1,
                          letterSpacing: -0.02, // Change hint text style
                        ),
                      ),
                      onChanged: (value) {
                        oldPassword = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'New Password',
                    style: GoogleFonts.poppins(
                      color: Color(0xFF363636),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 1,
                      letterSpacing: -0.02,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  Container(
                    width: 293, // Width in pixels
                    height: 50,

                    child: TextField(
                      controller: controllernew,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(0xFFC4C4C4),
                              width: 1), // Border color
                          borderRadius:
                              BorderRadius.circular(8), // Border radius
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 87, 87, 87),
                              width: 1), // Border color
                          borderRadius:
                              BorderRadius.circular(8), // Border radius
                        ),
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(
                          color: Color(0xFFA3A3A3),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1,
                          letterSpacing: -0.02, // Change hint text style
                        ),
                      ),
                      onChanged: (value) {
                        newPassword = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Retype Password',
                    style: GoogleFonts.poppins(
                      color: Color(0xFF363636),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 1,
                      letterSpacing: -0.02,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  Container(
                    width: 293, // Width in pixels
                    height: 50,

                    child: TextField(
                      controller: controllerrepeat,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(0xFFC4C4C4),
                              width: 1), // Border color
                          borderRadius:
                              BorderRadius.circular(8), // Border radius
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 87, 87, 87),
                              width: 1), // Border color
                          borderRadius:
                              BorderRadius.circular(8), // Border radius
                        ),
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(
                          color: Color(0xFFA3A3A3),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1,
                          letterSpacing: -0.02, // Change hint text style
                        ),
                      ),
                      onChanged: (value) {
                        repeatPassword = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 29,
                  ),
                  Center(
                    child: Text(
                      errorMessage,
                      style: TextStyle(
                        color: Color(0xFFFF0000),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  InkWell(
                    onTap: () {
                      print('change password tapped');
                      if (oldPassword != '' &&
                          newPassword != '' &&
                          newPassword == repeatPassword) {
                        BlocProvider.of<PasswordBloc>(context).add(
                            PostChangePassword(
                                oldPassword: oldPassword,
                                newPassword: newPassword,
                                repeatPassword: repeatPassword));
                        Navigator.pop(context);
                      } else if (oldPassword == '') {
                        setState(() {
                          errorMessage = "Please enter Old Password";
                        });
                      } else {
                        setState(() {
                          errorMessage =
                              "new password and repeat password dont match";
                        });
                      }
                    },
                    child: Container(
                        width: 293.0, // Set the width of the container
                        height: 50.0, // Set the height of the container
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                12), // Set the border-radius
                            color: Color(0xFF1A7A6C)),
                        child: Center(
                          child: Text(
                            'Reset Password',
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
        ));
  }
}
