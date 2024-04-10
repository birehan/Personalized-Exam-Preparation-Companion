import 'package:equatable/equatable.dart';

class ContestPrize extends Equatable {
  final String description;
  final int standing;
  final String type;
  final double amount;
  final String id;

  const ContestPrize(
      {required this.description,
      required this.standing,
      required this.type,
      required this.amount,
      required this.id});
  @override
  List<Object?> get props => [
        description,
        standing,
        type,
        amount,
        id,
      ];
}
