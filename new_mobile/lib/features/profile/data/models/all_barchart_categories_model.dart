import 'package:skill_bridge_mobile/features/profile/data/models/score_category_for_charts_model.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/all_barchart_categories_entity.dart';

class ScoreCategoryListModel extends ScoreCategoryListEntity {
  const ScoreCategoryListModel({
    required super.userCategory,
    required super.categories,
  });

  factory ScoreCategoryListModel.fromJson(Map<String, dynamic> json) {
    return ScoreCategoryListModel(
      userCategory: ScoreCategoryModel.fromJson(json['userCategory']),
      categories: (json['categories'] as List)
          .map((category) => ScoreCategoryModel.fromJson(category))
          .toList(),
    );
  }
}
