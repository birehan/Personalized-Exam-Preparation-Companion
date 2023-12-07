import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class OtpWidget extends StatelessWidget {
  const OtpWidget({
    super.key,
    required this.controllers,
    required this.dispatchOtp,
    required this.prevPage,
    required this.isEmail,
    required this.emailOrPhoneNumber,
  });

  final bool isEmail;
  final List<TextEditingController> controllers;
  final Function(String) dispatchOtp;
  final String prevPage;
  final String emailOrPhoneNumber;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is ForgetPasswordState && state.status == AuthStatus.loaded) {
          ChangePasswordPageRoute().go(context);
          // context.push(AppRoutes.changePassword);
        } else if (state is ForgetPasswordState &&
            state.status == AuthStatus.error) {
          final snackBar = SnackBar(
            content: Text(
              state.errorMessage!,
              style: GoogleFonts.poppins(
                color: Colors.white,
              ),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Stack(
        children: [
          otpWidget(),
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is ForgetPasswordState &&
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
          )
        ],
      ),
    );
  }

  Scaffold otpWidget() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/images/otp_image.png'),
              const SizedBox(height: 16),
              Text(
                'Verfication code',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF363636),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We have sent a verification code to your ${isEmail ? 'email address' : 'phone number'}',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF949494),
                ),
              ),
              const SizedBox(height: 20),
              if (prevPage == AppRoutes.forgotPassword)
                BlocBuilder<ChangePasswordFormBloc, ChangePasswordForm>(
                  builder: (context, state) {
                    return EmailDisplayWidget(
                      email: state.emailOrPhoneNumber,
                    );
                  },
                )
              else
                BlocBuilder<SignupFormBloc, SignupForm>(
                  builder: (context, state) {
                    return EmailDisplayWidget(
                      email: emailOrPhoneNumber,
                    );
                  },
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ...controllers.map(
                    (controller) => OTPFieldWidget(
                      controller: controller,
                      index: controllers.indexOf(controller),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SubmitOTPVerificationWidget(
                      dispatchOtp: dispatchOtp,
                      prevPage: prevPage,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (prevPage == AppRoutes.forgotPassword)
                BlocBuilder<ChangePasswordFormBloc, ChangePasswordForm>(
                  builder: (context, state) {
                    return SendAgainWidget(
                      emailOrPhoneNumber: state.emailOrPhoneNumber,
                    );
                  },
                )
              else
                BlocBuilder<SignupFormBloc, SignupForm>(
                  builder: (context, state) {
                    return SendAgainWidget(
                      emailOrPhoneNumber: state.emailOrPhoneNumber,
                    );
                  },
                ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       'Edit email?',
              //       style: GoogleFonts.poppins(
              //         fontSize: 14,
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //     if (prevPage == AppRoutes.forgotPassword)
              //       BlocBuilder<ChangePasswordFormBloc, ChangePasswordForm>(
              //         builder: (context, state) {
              //           return SendAgainWidget(
              //             email: state.email,
              //           );
              //         },
              //       )
              //     else
              //       BlocBuilder<SignupFormBloc, SignupForm>(
              //         builder: (context, state) {
              //           return SendAgainWidget(
              //             email: state.email,
              //           );
              //         },
              //       ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
