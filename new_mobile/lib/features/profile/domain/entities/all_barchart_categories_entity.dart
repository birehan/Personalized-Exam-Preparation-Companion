import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/score_category_for_charts_entity.dart';

class ScoreCategoryListEntity extends Equatable {
  final ScoreCategoryEntity userCategory;
  final List<ScoreCategoryEntity> categories;

  const ScoreCategoryListEntity(
      {required this.userCategory, required this.categories});

  @override
  List<Object?> get props => [
        userCategory,
        categories,
      ];
}
