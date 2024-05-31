import '../core.dart';

String getCompliment(double score, resultPageParams) {
  if (score >= 90) {
    return resultPageParams.examType == ExamType.quiz
        ? "Quiz Master!"
        : "Mock Master!";
  } else if (score >= 80) {
    return "Impressive performance!";
  } else if (score >= 70) {
    return "Well done!";
  } else if (score >= 60) {
    return "Nice job!";
  } else {
    return "Keep practicing!";
  }
}
