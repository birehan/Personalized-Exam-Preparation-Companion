import 'package:equatable/equatable.dart';

class SubjectsEntity extends Equatable {
  final String title;
  final String image;

  const SubjectsEntity({required this.title, required this.image});
  @override
  // TODO: implement props
  List<Object?> get props => [title, image];
}
