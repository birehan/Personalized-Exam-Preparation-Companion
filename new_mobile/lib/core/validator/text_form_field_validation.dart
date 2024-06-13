import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String? validateEmail(String? email) {
  if (email == null || email.isEmpty) {
    return 'Email is required';
  } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
      .hasMatch(email.trim())) {
    return 'Invalid email format';
  }

  return null;
}

String? validatePhoneNumber(String? phoneNumber) {
  if (phoneNumber != null) {
    phoneNumber = phoneNumber.trim();
  }
  if (phoneNumber == null || phoneNumber.isEmpty) {
    return 'Phone number is required';
  } else if (!RegExp(r'^(\+[0-9]{1,4})?[0-9]{10}$').hasMatch(phoneNumber)) {
    return 'Invalid phone number format';
  }

  return null;
}

String? validateEmailOrPhoneNumber(
    String? emailOrPhoneNumber, BuildContext context) {
  var localizedContext = context;
  final emailError = validateEmail(emailOrPhoneNumber);
  final phoneError = validatePhoneNumber(emailOrPhoneNumber);

  if (emailError == null || phoneError == null) {
    return null; // Either email or phone is valid
  } else {
    return AppLocalizations.of(localizedContext)!
        .enter_a_valid_email_or_phone_number;
  }
}

String? validateFullName(String? fullName, BuildContext context) {
  var localizedContext = context;
  if (fullName == null || fullName.isEmpty) {
    return AppLocalizations.of(localizedContext)!.full_name_is_required;
  } else if (fullName.trim().split(' ').length < 2) {
    return AppLocalizations.of(localizedContext)!
        .enter_both_first_and_last_name;
  }

  return null;
}

String? validatePassword(String? password, BuildContext context) {
  var localizedContext = context;
  if (password == null || password.isEmpty) {
    return AppLocalizations.of(localizedContext)!.password_is_required;
  } else if (password.length < 6) {
    return AppLocalizations.of(localizedContext)!
        .password_must_be_at_least_6_characters_long;
  }

  return null;
}

String? validatePasswordAndConfirmPassword(
    String? password, String? confirmPassword, BuildContext context) {
  var localizedContext = context;
  if (password == null || password.isEmpty) {
    return AppLocalizations.of(localizedContext)!.password_is_required;
  } else if (password.length < 6) {
    return AppLocalizations.of(localizedContext)!
        .password_must_be_at_least_6_characters_long;
  }
  // else if (!RegExp(r'[A-Z]').hasMatch(password)) {
  //   return 'Password must contain at least one uppercase letter';
  // } else if (!RegExp(r'[a-z]').hasMatch(password)) {
  //   return 'Password must contain at least one lowercase letter';
  // } else if (!RegExp(r'\d').hasMatch(password)) {
  //   return 'Password must contain at least one digit';
  // }
  else if (confirmPassword != password) {
    return AppLocalizations.of(localizedContext)!.passwords_do_not_match;
  }

  return null;
}

String? validateQuizTitle(String? quizTitle, BuildContext context) {
  var localizedContext = context;
  if (quizTitle == null || quizTitle.isEmpty) {
    return AppLocalizations.of(localizedContext)!.please_enter_a_title;
  }
  return null;
}

String? validateQuizQuestionsNumber(
    String? questionNumber, BuildContext context) {
  var localizedContext = context;
  if (questionNumber == null || questionNumber.isEmpty) {
    return AppLocalizations.of(localizedContext)!
        .please_enter_number_of_questions;
  }
  int? number = int.tryParse(questionNumber);
  if (number != null) {
    return number > 0
        ? null
        : AppLocalizations.of(localizedContext)!
            .quiz_questions_should_be_more_than_0;
  } else {
    return AppLocalizations.of(localizedContext)!
        .invalid_input_please_enter_a_valid_integer;
  }
}
