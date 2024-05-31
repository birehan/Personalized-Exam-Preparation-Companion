import 'package:skill_bridge_mobile/features/profile/domain/entities/score_category_for_charts_entity.dart';

class ScoreCategoryModel extends ScoreCategoryEntity {
  const ScoreCategoryModel({
    required super.id,
    required super.start,
    required super.end,
    required super.count,
    required super.percentile,
    super.userScore,
    required super.range,
  });

  factory ScoreCategoryModel.fromJson(Map<String, dynamic> json) {
    return ScoreCategoryModel(
      id: json['_id'] ?? '',
      start: json['start'] ?? 0,
      end: json['end'] ?? 0,
      count: json['count'] ?? 0,
      percentile: json['percentile'] ?? 0,
      range: json['top'] ?? 0,
      userScore: json['userScore'] ?? 0,
    );
  }
}
