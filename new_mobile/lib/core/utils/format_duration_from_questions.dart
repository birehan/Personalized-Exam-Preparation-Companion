String formatDurationFromQuestions(int numberOfQuestions) {
  // Calculate the total duration in minutes based on the number of questions
  int totalMinutes = numberOfQuestions * 1; // Assuming 1 minutes per question

  // Calculate hours and minutes
  int hours = totalMinutes ~/ 60;
  int minutes = totalMinutes % 60;

  // Build the formatted duration string
  String formattedDuration = '';
  if (hours > 0) {
    formattedDuration += '$hours h';
  }
  if (minutes > 0) {
    if (formattedDuration.isNotEmpty) {
      formattedDuration += ' ';
    }
    formattedDuration += '$minutes min';
  }
  if (formattedDuration.isEmpty) {
    formattedDuration = '0 min'; // Default to 0 minutes if no questions.
  }

  return formattedDuration;
}
