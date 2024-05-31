import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/core.dart';
import '../../../../core/utils/snack_bar.dart';
import '../../../features.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({
    super.key,
    required this.emailOrPhoneNumber,
    required this.from,
  });

  final String emailOrPhoneNumber;
  final String from;

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  bool isEmail = true;

  @override
  void initState() {
    super.initState();
    final signupFormState = context.read<SignupFormBloc>().state;
    if (validateEmail(signupFormState.emailOrPhoneNumber) != null) {
      setState(() {
        isEmail = false;
      });
    }
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void dispatchOtp(String emailOrPhoneNumber) {
    String otp = pinController.text;
    // for (TextEditingController controller in controllers) {
    //   otp += controller.text;
    // }

    if (widget.from == ForgotPasswordPageRoute().location) {
      context
          .read<ChangePasswordFormBloc>()
          .add(ChangeOTPForChangePasswordForm(otp: otp));
      context.read<AuthenticationBloc>().add(
            ForgetPasswordEvent(
              emailOrPhoneNumber: emailOrPhoneNumber,
              otp: otp,
            ),
          );
    } else if (widget.from == SignupPageRoute().location) {
      final signupFormState = context.read<SignupFormBloc>().state;
      context.read<AuthenticationBloc>().add(
            SignupEvent(
              emailOrPhoneNumber: signupFormState.emailOrPhoneNumber,
              password: signupFormState.password,
              firstName: signupFormState.firstName,
              lastName: signupFormState.lastName,
              otp: otp,
            ),
          );
    }
  }

  void showErrorMessage(String? message) {
    final snackBar = SnackBar(
      content: Text(
        message ?? 'Unknow error happened, please try again.',
        style: GoogleFonts.poppins(
          color: Colors.white,
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color.fromARGB(255, 172, 68, 61),
    );
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is ResendOtpVerificationState &&
            state.status == AuthStatus.loaded) {
          final snackBar = SnackBar(
            content: Text(
              'OTP code has been sent successfully....',
              style: GoogleFonts.poppins(
                color: Colors.white,
              ),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (state is ResendOtpVerificationState &&
            state.status == AuthStatus.error) {
          showErrorMessage(state.errorMessage);
        } else if (state is SendOtpVerificationState &&
            state.status == AuthStatus.error) {
          showErrorMessage(state.errorMessage);
        } else if (state is SignupState && state.status == AuthStatus.error) {
          showErrorMessage(state.errorMessage);
        } else if (state is SignupState && state.status == AuthStatus.loaded) {
          OnboardingQuestionPagesRoute().go(context);
          // context.go(AppRoutes.questionOnboardingPages);
        }
      },
      child: Stack(
        children: [
          OtpWidget(
            isEmail: isEmail,
            dispatchOtp: dispatchOtp,
            prevPage: widget.from,
            emailOrPhoneNumber: widget.emailOrPhoneNumber,
            controller: pinController,
            focusNode: focusNode,
          ),
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is ResendOtpVerificationState &&
                  state.status == AuthStatus.loading) {
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
          ),
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is SendOtpVerificationState &&
                  state.status == AuthStatus.loading) {
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
          ),
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
          ),
        ],
      ),
    );
  }
}
