import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/core.dart';
import '../../../../core/utils/snack_bar.dart';
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
          print('email or phone number: ${_emailOrPhoneNumberController.text}');
          ForgotPasswordOtpPageRoute(
            emailOrPhoneNumber: _emailOrPhoneNumberController.text,
          ).go(context);
          // context.push(
          //   AppRoutes.otpPage,
          //   extra: AppRoutes.forgotPassword,
          // );
        } else if (state is SendOtpVerificationState &&
            state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context)
              .showSnackBar(snackBar(state.failure!.errorMessage));
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
                AppLocalizations.of(context)!.reset_password,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF363636),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!
                    .enter_the_email_or_phone_number_associated_with_your_account_and_we_will_send_an_otp_code_so_that_you_can_reset_your_password,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF777777),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.email_or_phone_number,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF363636),
                ),
              ),
              TextFormField(
                controller: _emailOrPhoneNumberController,
                validator: (emailOrPhoneNumber) {
                  return validateEmailOrPhoneNumber(
                      emailOrPhoneNumber, context);
                },
                cursorColor: const Color(0xFF0072FF),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  hintText: AppLocalizations.of(context)!
                      .enter_your_email_or_phone_number,
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
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
                                  isForForgotPassword: true,
                                ),
                              );
                        }
                      },
                      child: Text(
                        AppLocalizations.of(context)!.send_code,
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
