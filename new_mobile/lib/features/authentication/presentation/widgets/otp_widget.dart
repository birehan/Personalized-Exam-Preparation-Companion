import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/core.dart';
import '../../../../core/utils/snack_bar.dart';
import '../../../features.dart';

class OtpWidget extends StatelessWidget {
  const OtpWidget({
    super.key,
    required this.dispatchOtp,
    required this.prevPage,
    required this.isEmail,
    required this.emailOrPhoneNumber,
    required this.controller,
    required this.focusNode,
  });

  final bool isEmail;

  final Function(String) dispatchOtp;
  final String prevPage;
  final String emailOrPhoneNumber;
  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is ForgetPasswordState && state.status == AuthStatus.loaded) {
          ChangePasswordPageRoute().go(context);
          // context.push(AppRoutes.changePassword);
        } else if (state is ForgetPasswordState &&
            state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context)
              .showSnackBar(snackBar(state.errorMessage));
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
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: GoogleFonts.poppins(
        fontSize: 22,
        color: const Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: const BoxDecoration(),
    );
    final cursor = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 56,
          height: 1,
          decoration: BoxDecoration(
            color: const Color(0xFF0072FF),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
    final preFilledWidget = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 56,
          height: 1,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10.h),
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
                Pinput(
                  length: 6,
                  controller: controller,
                  focusNode: focusNode,
                  preFilledWidget: preFilledWidget,
                  androidSmsAutofillMethod:
                      AndroidSmsAutofillMethod.smsUserConsentApi,
                  listenForMultipleSmsOnAndroid: true,
                  defaultPinTheme: defaultPinTheme,
                  separatorBuilder: (index) => const SizedBox(width: 8),
                  validator: (value) {
                    return value != null && value.length == 6
                        ? null
                        : 'Code is incorrect';
                  },
                  animationDuration: const Duration(milliseconds: 100),
                  pinAnimationType: PinAnimationType.slide,

                  hapticFeedbackType: HapticFeedbackType.lightImpact,
                  onCompleted: (pin) {
                    debugPrint('onCompleted: $pin');
                  },
                  onChanged: (value) {
                    debugPrint('onChanged: $value');
                  },
                  cursor: cursor,
                  submittedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      // color: fillColor,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: const Color(0xFF0072FF),
                      ),
                    ),
                  ),

                  errorPinTheme: defaultPinTheme.copyBorderWith(
                    border: Border.all(color: Colors.redAccent),
                  ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
