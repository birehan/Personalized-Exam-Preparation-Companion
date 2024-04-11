import 'package:equatable/equatable.dart';

class CourseImage extends Equatable {
  final String imageAddress;

  const CourseImage({required this.imageAddress});

  @override
  List<Object?> get props => [imageAddress];
}
