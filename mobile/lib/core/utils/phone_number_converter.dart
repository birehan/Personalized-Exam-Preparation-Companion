String phoneNumberConverter(String phoneNumber) {
  if (phoneNumber.startsWith('+')) {
    return phoneNumber;
  }
  return '+251${phoneNumber.substring(1)}';
}
