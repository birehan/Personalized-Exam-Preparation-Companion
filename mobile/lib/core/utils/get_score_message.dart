String getScoreMessage(double score) {
  if (score == 100) {
    return 'Congratulations for getting all the answers';
  } else if (score >= 90) {
    return "Congratulations! You scored an excellent result!";
  } else if (score >= 80) {
    return "Great job! You performed very well!";
  } else if (score >= 70) {
    return "Well done! You achieved a good score.";
  } else if (score >= 60) {
    return "You did decently. Keep practicing to improve!";
  } else {
    return "You need to work harder to improve your score.";
  }
}
