import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/bloc/changePasswordBloc/password_bloc.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/bloc/changePasswordBloc/password_event.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/bloc/changePasswordBloc/password_state.dart';

class ProfileEditpageMenuIcon extends StatelessWidget {
  const ProfileEditpageMenuIcon({
    super.key,
    required this.oldPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
  });

  final TextEditingController oldPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    void showStatusMessage({String? message, required bool successful}) {
      final snackBar = SnackBar(
        content: Text(
          message ?? 'Unknow error happened, please try again.',
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor:
            successful ? Colors.green : const Color.fromARGB(255, 172, 68, 61),
      );
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return IconButton(
      onPressed: () {
        showMenu(
          context: context,
          position: const RelativeRect.fromLTRB(100, 40, 0, 0),
          elevation: 2,
          color: Colors.white,
          shadowColor: Colors.black12,
          items: [
            PopupMenuItem(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: .5.h),
              onTap: () {
                showGeneralDialog(
                  transitionDuration: const Duration(milliseconds: 200),
                  context: context,
                  // barrierDismissible: true,
                  pageBuilder: (context, animation, animation2) {
                    return Container();
                  },
                  transitionBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return ScaleTransition(
                      scale:
                          Tween<double>(begin: .5, end: 1.0).animate(animation),
                      child: Theme(
                        data: ThemeData(
                          inputDecorationTheme: const InputDecorationTheme(
                            // Set the border color for TextField
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff18786a)),
                            ),
                            // Add more InputDecoration styles if needed
                          ),
                        ),
                        child: AlertDialog(
                          titleTextStyle: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                          title: const Text('Change Password'),
                          backgroundColor: Colors.white,
                          content: SizedBox(
                            height: 30.h,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  PasswordChangeTextFieldWidget(
                                    oldPasswordController:
                                        oldPasswordController,
                                    labelText: 'Old Password',
                                  ),
                                  SizedBox(height: 2.h),
                                  PasswordChangeTextFieldWidget(
                                    oldPasswordController:
                                        newPasswordController,
                                    labelText: 'New Password',
                                  ),
                                  SizedBox(height: 2.h),
                                  PasswordChangeTextFieldWidget(
                                    oldPasswordController:
                                        confirmPasswordController,
                                    labelText: 'Confirm Password',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            BlocBuilder<PasswordBloc, PasswordState>(
                              builder: (context, state) {
                                if (state is PasswordChangeLoadingState) {
                                  return Container();
                                }
                                return TextButton(
                                  child: const Text('Cancel',
                                      style: TextStyle(
                                          color: Color(0xff18786a),
                                          fontFamily: 'Poppins')),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                            BlocConsumer<PasswordBloc, PasswordState>(
                              listener: (context, state) {
                                if (state is PasswordChangeFailedState) {
                                  Navigator.pop(context);
                                  showStatusMessage(
                                      message:
                                          'Password change not successful.',
                                      successful: false);
                                } else if (state is PasswordChangedState) {
                                  Navigator.pop(context);
                                  showStatusMessage(
                                      message:
                                          'You have successfully changed your password.',
                                      successful: true);
                                }
                              },
                              builder: (context, state) {
                                if (state is PasswordChangeLoadingState) {
                                  return const CustomProgressIndicator(
                                    size: 18,
                                  );
                                }
                                return TextButton(
                                  child: const Text('Change',
                                      style: TextStyle(
                                          color: Color(0xff18786a),
                                          fontFamily: 'Poppins')),
                                  onPressed: () {
                                    context.read<PasswordBloc>().add(
                                          PostChangePassword(
                                              newPassword:
                                                  newPasswordController.text,
                                              oldPassword:
                                                  oldPasswordController.text,
                                              repeatPassword:
                                                  newPasswordController.text),
                                        );
                                    // Navigator.pop(context);
                                  },
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Text('Change Password'),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        );
      },
      icon: const Icon(Icons.more_vert_rounded),
    );
  }
}

class PasswordChangeTextFieldWidget extends StatefulWidget {
  const PasswordChangeTextFieldWidget({
    super.key,
    required this.oldPasswordController,
    required this.labelText,
  });

  final TextEditingController oldPasswordController;
  final String labelText;

  @override
  State<PasswordChangeTextFieldWidget> createState() =>
      _PasswordChangeTextFieldWidgetState();
}

class _PasswordChangeTextFieldWidgetState
    extends State<PasswordChangeTextFieldWidget> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: .5.h),
        TextField(
          controller: widget.oldPasswordController,
          decoration: InputDecoration(
            // labelText: '*************',
            hintText: '*************',
            contentPadding:
                EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xff18786a)),
              borderRadius: BorderRadius.circular(5),
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscureText = !obscureText;
                });
              },
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF18786A),
              ),
            ),
          ),
          obscureText: obscureText,
        ),
      ],
    );
  }
}
