import '../../features/onboarding/domain/entities/subjects_entity.dart';

const List<SubjectsEntity> naturalSubjects = [
  SubjectsEntity(image: "assets/images/Chemistry.png", title: 'Chemistry'),
  SubjectsEntity(image: "assets/images/Biology.png", title: 'Biology'),
  SubjectsEntity(image: "assets/images/maths.png", title: 'Mathematics'),
  SubjectsEntity(image: "assets/images/Physics.png", title: 'physics'),
  // SubjectsEntity(image: "assets/images/Civics.png", title: 'Civics'),
  SubjectsEntity(image: "assets/images/SAT.png", title: 'SAT'),
  SubjectsEntity(image: "assets/images/English.png", title: 'English')
];

const List<SubjectsEntity> socialSubjects = [
  SubjectsEntity(image: "assets/images/maths.png", title: 'Mathematics'),
  SubjectsEntity(image: "assets/images/Civics.png", title: 'Civics'),
  SubjectsEntity(image: "assets/images/SAT.png", title: 'SAT'),
  SubjectsEntity(image: "assets/images/English.png", title: 'English'),
  SubjectsEntity(image: "assets/images/Geography.png", title: 'Geography'),
  SubjectsEntity(image: "assets/images/History.png", title: 'History'),
  SubjectsEntity(
      image: "assets/images/Economics_subject.png", title: 'Economics'),
];
Map<String, String> naturalSubjectImagesMap = {
  "chemistry": "assets/images/Chemistry.png",
  "biology": "assets/images/Biology.png",
  "mathematics": "assets/images/maths.png",
  "physics": "assets/images/Physics.png",
  // "civics": "assets/images/Civics.png",
  "sat": "assets/images/SAT.png",
  "english": "assets/images/English.png",
};
Map<String, String> socialSubjectImagesMap = {
  "mathematics": "assets/images/maths.png",
  "civics": "assets/images/Civics.png",
  "sat": "assets/images/SAT.png",
  "english": "assets/images/English.png",
  "geography": "assets/images/Geography.png",
  "history": "assets/images/History.png",
  "economics": "assets/images/Economics_subject.png"
};

List<String> howPrepared = [
  'Very prepared',
  'Somewhat prepared',
  'Not prepared at all'
];

List<String> preferedMethod = [
  'Reading and taking notes',
  'Interactive exercises and practice'
];

List<String> studyTimePerday = [
  'Less than 1 hour',
  '1-2 hours',
  '2-3 hours',
  'More than 3 hours'
];

List<String> motivation = [
  'Achieving academic success',
  'Personal growth and improvement',
];

List<String> streamId = [
  "64c24df185876fbb3f8dd6c7", //natiral
  "64c24e0e85876fbb3f8dd6ca" //social
];
