import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:prep_genie/features/authentication/presentation/widgets/siginin_with_google.dart';
import 'package:prep_genie/injection_container.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/core.dart';
import '../../../../core/utils/snack_bar.dart';
import '../../authentication.dart';
// import '../../../../core/routes/app_routes.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailOrPhoneNumberController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _passwordController = TextEditingController();
  // bool _isChecked = false;
  bool _passwordVisible = false;

  final _formKey = GlobalKey<FormState>();
  void manageReferalData() async {
    final localDataSource = serviceLocator<AuthenticationLocalDatasource>();
    String? referalCode = await localDataSource.getReferralId();
    if (referalCode != null) {
      print('referral code: $referalCode');
    }
  }

  @override
  void dispose() {
    _emailOrPhoneNumberController.dispose();
    _fullNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void dispatchSignup() {
    context.read<AuthenticationBloc>().add(SendOtpVerficationEvent(
          emailOrPhoneNumber: _emailOrPhoneNumberController.text.trim(),
          isForForgotPassword: false,
        ));
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
        if (state is SendOtpVerificationState &&
            state.status == AuthStatus.loaded) {
          List<String> fullName = _fullNameController.text.trim().split(' ');
          final firstName = fullName[0];
          final lastName = fullName.length >= 2 ? fullName[1] : 'lastName';
          context.read<SignupFormBloc>().add(ChangeEmailEvent(
              email: _emailOrPhoneNumberController.text.trim()));
          context
              .read<SignupFormBloc>()
              .add(ChangeFirstNameEvent(firstName: firstName));
          context
              .read<SignupFormBloc>()
              .add(ChangeLastNameEvent(lastName: lastName));
          context
              .read<SignupFormBloc>()
              .add(ChangePassEvent(password: _passwordController.text));

          SignupOtpPageRoute(
            emailOrPhoneNumber: _emailOrPhoneNumberController.text,
          ).go(context);
          // context.push(
          //   AppRoutes.otpPage,
          //   extra: AppRoutes.signup,
          // );
        } else if (state is SendOtpVerificationState &&
            state.status == AuthStatus.error) {
          showErrorMessage(state.errorMessage);
        }
        // SignIn with Google Bloc Listener
        else if (state is SignInWithGoogleState &&
            state.status == AuthStatus.loaded) {
          final user = state.userCredential!;
          if (user.department != null) {
            context.read<StoreDeviceTokenBloc>().add(
                  const StoreDeviceTokenEvent(),
                );
            HomePageRoute().go(context);
          } else {
            OnboardingQuestionPagesRoute().go(context);
          }
        } else if (state is SignInWithGoogleState &&
            state.status == AuthStatus.error) {
          final snackBar = SnackBar(content: Text(state.errorMessage!));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Stack(
        children: [
          signupForm(context),
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if ((state is SendOtpVerificationState &&
                      state.status == AuthStatus.loading) ||
                  (state is SignInWithGoogleState &&
                      state.status == AuthStatus.loading)) {
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

  Scaffold signupForm(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/logo_3.png',
                        width: 60,
                        height: 60,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'PrepGenie',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    Text(
                      AppLocalizations.of(context)!.let_us_get_started,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0072FF),
                      ),
                    ),
                    // Text(
                    //   'Start Learning today!',
                    //   style: GoogleFonts.poppins(
                    //     fontSize: 13,
                    //     fontWeight: FontWeight.w500,
                    //     color: const Color(0xFFA3A2B1),
                    //   ),
                    // ),
                    const SizedBox(height: 32),
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
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
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
                    const SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context)!.full_name,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF363636),
                      ),
                    ),
                    TextFormField(
                      controller: _fullNameController,
                      validator: (fullName) {
                        return validateFullName(fullName, context);
                      },
                      cursorColor: const Color(0xFF0072FF),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        hintText:
                            AppLocalizations.of(context)!.enter_your_full_name,
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
                    const SizedBox(height: 20),
                    Text(
                      AppLocalizations.of(context)!.password,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF363636),
                      ),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      validator: (value) {
                        return validatePassword(value, context);
                      },
                      obscureText: !_passwordVisible,
                      cursorColor: const Color(0xFF0072FF),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        hintText:
                            AppLocalizations.of(context)!.enter_your_password,
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF0072FF),
                            width: 2,
                          ),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color(0xFF0072FF),
                          ),
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF363636),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // GestureDetector(
                    //   onTap: () {
                    //     setState(() {
                    //       _isChecked = !_isChecked;
                    //     });
                    //   },
                    //   child: Row(
                    //     children: [
                    //       CustomCheckBox(
                    //         isChecked: _isChecked,
                    //         onTap: () {
                    //           setState(() {
                    //             _isChecked = !_isChecked;
                    //           });
                    //         },
                    //       ),
                    //       const SizedBox(width: 8),
                    //       Text(
                    //         'I agree to the terms and conditions',
                    //         style: GoogleFonts.poppins(
                    //           fontSize: 14,
                    //           fontWeight: FontWeight.w500,
                    //           color: const Color(0xFF363636),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              manageReferalData();
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                // Perform further actions with the valid input

                                dispatchSignup();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0072FF),
                              foregroundColor: const Color(0xFFFFFFFF),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.sign_up,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    SignInWithGoogleWidget(
                      text: AppLocalizations.of(context)!.sign_in_with_google,
                    ),
                    //? This comment is intentional, it is needed for the next MVP
                    // const SizedBox(height: 24),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Container(
                    //       width: 100,
                    //       height: 1,
                    //       color: const Color(0xFFC5C5C5),
                    //     ),
                    //     Text(
                    //       'or Sign Up With',
                    //       style: GoogleFonts.poppins(
                    //         fontSize: 14,
                    //         fontWeight: FontWeight.w500,
                    //         color: const Color(0xFF363636),
                    //       ),
                    //     ),
                    //     Container(
                    //       width: 100,
                    //       height: 1,
                    //       color: const Color(0xFFC5C5C5),
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 24),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: OutlinedButton(
                    //         onPressed: () {
                    //           context
                    //               .read<AuthenticationBloc>()
                    //               .add(SignInWithGoogleEvent());
                    //         },
                    //         style: OutlinedButton.styleFrom(
                    //           padding: const EdgeInsets.symmetric(
                    //               horizontal: 16, vertical: 12),
                    //           shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.circular(12),
                    //           ),
                    //         ),
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             Image.asset(
                    //               'assets/images/google_icon.png',
                    //               width: 20,
                    //               height: 20,
                    //             ),
                    //             const SizedBox(width: 14),
                    //             Text(
                    //               'Google',
                    //               style: GoogleFonts.poppins(
                    //                 fontSize: 14,
                    //                 fontWeight: FontWeight.w500,
                    //                 color: const Color(0xFF363636),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.already_have_an_account,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF363636),
                    ),
                  ),
                  const SizedBox(width: 4),
                  TextButton(
                    onPressed: () {
                      // context.go(AppRoutes.login);
                      LoginPageRoute().go(context);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.login,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0072FF),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}