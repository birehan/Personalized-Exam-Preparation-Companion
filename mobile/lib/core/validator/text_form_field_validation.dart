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
  if (phoneNumber == null || phoneNumber.isEmpty) {
    return 'Phone number is required';
  } else if (!RegExp(r'^(\+[0-9]{1,4})?[0-9]{10}$').hasMatch(phoneNumber)) {
    return 'Invalid phone number format';
  }

  return null;
}

String? validateEmailOrPhoneNumber(String? emailOrPhoneNumber) {
  final emailError = validateEmail(emailOrPhoneNumber);
  final phoneError = validatePhoneNumber(emailOrPhoneNumber);

  if (emailError == null || phoneError == null) {
    return null; // Either email or phone is valid
  } else {
    return 'Enter a valid email or phone number';
  }
}

String? validateFullName(String? fullName) {
  if (fullName == null || fullName.isEmpty) {
    return 'Full name is required';
  } else if (fullName.trim().split(' ').length < 2) {
    return 'Enter both first and last name';
  }

  return null;
}

String? validatePassword(String? password) {
  if (password == null || password.isEmpty) {
    return 'Password is required';
  } else if (password.length < 6) {
    return 'Password must be at least 6 characters long';
  }
  // else if (!RegExp(r'[A-Z]').hasMatch(password)) {
  //   return 'Password must contain at least one uppercase letter';
  // } else if (!RegExp(r'[a-z]').hasMatch(password)) {
  //   return 'Password must contain at least one lowercase letter';
  // } else if (!RegExp(r'\d').hasMatch(password)) {
  //   return 'Password must contain at least one digit';
  // }

  return null;
}

String? validatePasswordAndConfirmPassword(
    String? password, String? confirmPassword) {
  if (password == null || password.isEmpty) {
    return 'Password is required';
  } else if (password.length < 6) {
    return 'Password must be at least 6 characters long';
  }
  // else if (!RegExp(r'[A-Z]').hasMatch(password)) {
  //   return 'Password must contain at least one uppercase letter';
  // } else if (!RegExp(r'[a-z]').hasMatch(password)) {
  //   return 'Password must contain at least one lowercase letter';
  // } else if (!RegExp(r'\d').hasMatch(password)) {
  //   return 'Password must contain at least one digit';
  // }
  else if (confirmPassword != password) {
    return 'Passwords do not match';
  }

  return null;
}

String? validateQuizTitle(String? quizTitle) {
  if (quizTitle == null || quizTitle.isEmpty) {
    return 'Please enter a title';
  }
  return null;
}

String? validateQuizQuestionsNumber(String? questionNumber) {
  if (questionNumber == null || questionNumber.isEmpty) {
    return 'Please enter number of questions';
  }
  int? number = int.tryParse(questionNumber);
  if (number != null) {
    return number > 0
        ? null
        : 'Quiz questions should be more than 0';
  } else {
    return 'Invalid input. Please enter a valid integer.';
  }
}
