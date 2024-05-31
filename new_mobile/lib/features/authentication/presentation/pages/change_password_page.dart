import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/core.dart';
import '../../../../core/utils/snack_bar.dart';
import '../../../features.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is ChangePasswordState && state.status == AuthStatus.loaded) {
          NewPasswordConfirmedPageRoute().go(context);
          // context.go(AppRoutes.newPasswordConfirmedPage);
        } else if (state is ChangePasswordState &&
            state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar(state.errorMessage));
        }
      },
      child: Stack(
        children: [
          changePasswordWidget(),
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
              if (state is ChangePasswordState &&
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

  Scaffold changePasswordWidget() {
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
                AppLocalizations.of(context)!.create_new_password,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF363636),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.set_a_secure_password_for_your_account_ensure_both_entries_match_before_submitting,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF777777),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.password,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF363636),
                ),
              ),
              TextFormField(
                controller: _passwordController,
                validator: (password) {
                  return validatePasswordAndConfirmPassword(
                    password,
                    _confirmPasswordController.text,
                    context
                  );
                },
                obscureText: !_passwordVisible,
                cursorColor: const Color(0xFF18786A),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  hintText: AppLocalizations.of(context)!.enter_your_password,
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
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.confirm_password,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF363636),
                ),
              ),
              TextFormField(
                controller: _confirmPasswordController,
                validator: (confirmPassword) {
                  return validatePasswordAndConfirmPassword(
                    confirmPassword,
                    _passwordController.text,
                    context
                  );
                },
                obscureText: !_confirmPasswordVisible,
                cursorColor: const Color(0xFF18786A),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  hintText: AppLocalizations.of(context)!.enter_your_password,
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
                        _confirmPasswordVisible = !_confirmPasswordVisible;
                      });
                    },
                    icon: Icon(
                      _confirmPasswordVisible
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
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child:
                        BlocBuilder<ChangePasswordFormBloc, ChangePasswordForm>(
                      builder: (context, state) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFF18786A),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 4,
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              context.read<AuthenticationBloc>().add(
                                    ChangePasswordEvent(
                                      emailOrPhoneNumber:
                                          state.emailOrPhoneNumber,
                                      newPassword: _passwordController.text,
                                      confirmPassword:
                                          _confirmPasswordController.text,
                                      otp: state.otp,
                                      context: context
                                    ),
                                  );
                            }
                          },
                          child: Text(
                            AppLocalizations.of(context)!.reset_password,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
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
