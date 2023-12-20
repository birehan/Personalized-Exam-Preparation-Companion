import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/core.dart';
import '../../authentication.dart';
import '../presentation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailOrPhoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = true;
  bool _passwordVisible = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailOrPhoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void dispatchLogin() {
    context.read<AuthenticationBloc>().add(
          LoginEvent(
            emailOrPhoneNumber: _emailOrPhoneNumberController.text.trim(),
            password: _passwordController.text,
            rememberMe: _rememberMe,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (_, state) {
        if (state is LoggedInState && state.status == AuthStatus.loaded) {
          HomePageRoute().go(context);
          // context.go(AppRoutes.myhomePage);
        } else if (state is LoggedInState && state.status == AuthStatus.error) {
          final snackBar = SnackBar(
            content: Text(
              state.errorMessage!,
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }

        // SignIn with Google Bloc Listener
        // if (state is SignInWithGoogleState &&
        //     state.status == AuthStatus.loading) {
        //   const snackBar =
        //       SnackBar(content: Text('sign in with google in progress...'));
        //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // } else if (state is SignInWithGoogleState &&
        //     state.status == AuthStatus.loaded) {
        //   context.push(AppRoutes.otpPage, extra: AppRoutes.login);
        // } else if (state is SignInWithGoogleState &&
        //     state.status == AuthStatus.error) {
        //   final snackBar = SnackBar(content: Text(state.errorMessage!));
        //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // }
      },
      child: Stack(
        children: [
          loginForm(context),
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is LoggedInState &&
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

  Scaffold loginForm(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
        child: SingleChildScrollView(
          child: SizedBox(
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
                          'SKILLBRIDGE',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      Text(
                        'Hi, Welcome Back!👋',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A7A6C),
                        ),
                      ),
                      // Text(
                      //   'Hello again, you\'ve been missed!',
                      //   style: GoogleFonts.poppins(
                      //     fontSize: 13,
                      //     fontWeight: FontWeight.w500,
                      //     color: const Color(0xFFA3A2B1),
                      //   ),
                      // ),
                      const SizedBox(height: 32),
                      Text(
                        'Email or Phone number',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF363636),
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      TextFormField(
                        controller: _emailOrPhoneNumberController,
                        validator: (emailOrPhoneNumber) {
                          return validateEmailOrPhoneNumber(emailOrPhoneNumber);
                        },
                        cursorColor: const Color(0xFF18786A),
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                          hintText: 'Enter your email or phone number',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF18786A),
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
                        'Password',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF363636),
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        validator: (password) {
                          return validatePassword(password);
                        },
                        obscureText: !_passwordVisible,
                        cursorColor: const Color(0xFF18786A),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          hintText: 'Enter your password',
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF18786A),
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
                              color: const Color(0xFF18786A),
                            ),
                          ),
                        ),
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF363636),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _rememberMe = !_rememberMe;
                          });
                        },
                        child: Row(
                          children: [
                            Container(),
                            // CustomCheckBox(
                            //   isChecked: _rememberMe,
                            //   onTap: () {
                            //     setState(() {
                            //       _rememberMe = !_rememberMe;
                            //     });
                            //   },
                            // ),
                            // const SizedBox(width: 8),
                            // Text(
                            //   'Remember Me',
                            //   style: GoogleFonts.poppins(
                            //     fontSize: 14,
                            //     fontWeight: FontWeight.w500,
                            //     color: const Color(0xFF363636),
                            //   ),
                            // ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                ForgotPasswordPageRoute().go(context);
                                // context.push(AppRoutes.forgotPassword);
                              },
                              child: Text(
                                'Forgot Password',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFFFF6652),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  dispatchLogin();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF18786A),
                                foregroundColor: const Color(0xFFFFFFFF),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Login',
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
                      //       'or Login With',
                      //       style: GoogleFonts.poppins(
                      //         fontSize: 16,
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
                      //                 fontSize: 16,
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
                      'Don\'t have an account?',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF363636),
                      ),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () {
                        context.go(AppRoutes.signup);
                      },
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF18786A),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
