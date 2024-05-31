import '../../../../core/core.dart';
import '../../../features.dart';

class MockUserRankModel extends MockUserRank {
  const MockUserRankModel({
    required super.id,
    required super.emailOrPhone,
    required super.firstName,
    required super.lastName,
    required super.department,
    required super.avatar,
    required super.score,
    required super.rank,
  });

  factory MockUserRankModel.fromJson(Map<String, dynamic> json) {
    return MockUserRankModel(
      id: json['user']['_id'],
      emailOrPhone: json['user']['email_phone'],
      firstName: json['user']['firstName'],
      lastName: json['user']['lastName'],
      department: json['user']['department'],
      avatar: json['user']['avatar'] ?? defaultProfileAvatar,
      score: json['score'],
      rank: json['rank'],
    );
  }
}
