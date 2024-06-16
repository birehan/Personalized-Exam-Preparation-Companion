import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class ExamCardParams extends Equatable {
  const ExamCardParams({
    required this.cardBackgroundColor,
    required this.title,
    required this.description,
    required this.imageAddress,
    required this.onPressed,
  });

  final Color cardBackgroundColor;
  final String title;
  final String description;
  final String imageAddress;
  final Function() onPressed;

  @override
  List<Object?> get props => [cardBackgroundColor, title, description, imageAddress, onPressed];
}
