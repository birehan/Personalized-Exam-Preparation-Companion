String timeFormatCalculate(Duration duration) {
  if (duration <= const Duration(seconds: 0)) {
    return 'Contest has ended';
  }

  int days = duration.inDays;
  int hours = duration.inHours.remainder(24);
  int minutes = duration.inMinutes.remainder(60);
  int seconds = duration.inSeconds.remainder(60);

  if (days > 0) {
    return "$days day $hours hr";
  } else if (hours > 0) {
    return "$hours hr $minutes min";
  } else {
    return "$minutes min $seconds sec";
  }
}
