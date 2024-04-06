import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailOrPhoneNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailOrPhoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is SendOtpVerificationState &&
            state.status == AuthStatus.loaded) {
          ForgotPasswordOtpPageRoute(
            emailOrPhoneNumber: _emailOrPhoneNumberController.text,
          ).go(context);
          // context.push(
          //   AppRoutes.otpPage,
          //   extra: AppRoutes.forgotPassword,
          // );
        } else if (state is SendOtpVerificationState &&
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
          forgetPasswordWidget(context),
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
                    ));
              }
              return Container();
            },
          )
        ],
      ),
    );
  }

  Scaffold forgetPasswordWidget(BuildContext context) {
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
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reset password',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF363636),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter the email associated with your account and we will send an OTP code so that you can reset your password',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF777777),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Email or Phone number',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF363636),
                ),
              ),
              TextFormField(
                controller: _emailOrPhoneNumberController,
                validator: (emailOrPhoneNumber) {
                  return validateEmailOrPhoneNumber(emailOrPhoneNumber);
                },
                cursorColor: const Color(0xFF0072FF),
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  hintText: 'Enter your email or phone number',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF0072FF),
                      width: 2,
                    ),
                  ),
                ),
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF363636),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF0072FF),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 4,
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          context.read<ChangePasswordFormBloc>().add(
                                ChangeEmailForChangePasswordForm(
                                  email: _emailOrPhoneNumberController.text,
                                ),
                              );
                          context.read<AuthenticationBloc>().add(
                                SendOtpVerficationEvent(
                                  emailOrPhoneNumber:
                                      _emailOrPhoneNumberController.text,
                                ),
                              );
                        }
                      },
                      child: Text(
                        'Send Code',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
