import 'package:equatable/equatable.dart';

class ScoreCategoryEntity extends Equatable {
  final String id;
  final num start;
  final num end;
  final int count;
  final num percentile;
  final num range;
  final num? userScore;

  const ScoreCategoryEntity(
      {required this.id,
      required this.start,
      required this.end,
      required this.count,
      required this.percentile,
      required this.range,
      this.userScore});

  @override
  List<Object?> get props => [
        id,
        start,
        end,
        count,
        percentile,
        range,
        userScore,
      ];
}
