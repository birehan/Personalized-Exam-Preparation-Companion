// import '../../domain/entities/user_profile_entity.dart';

// class UserProfileModel extends UserProfile {
//   const UserProfileModel({
//     required super.email,
//     super.department,
//     super.firstName,
//     super.lastName,
//     super.profileAvatarUrl,
//     super.imageAdress,
//     super.major,
//     super.examType,
//   });

//   factory UserProfileModel.fromJson(Map<String, dynamic> json) {
//     return UserProfileModel(
//         email: json['updatedUser']['email'],
//         department: json['updatedUser']['department'] != null
//             ? json['updatedUser']['department']['name']
//             : '',
//         firstName: json['updatedUser']['firstName'] ?? '',
//         lastName: json['updatedUser']['lastName'] ?? '',
//         imageAdress: json['updatedUser']['avatar'] == null
//             ? null
//             : json['updatedUser']['avatar']['imageAddress'],
//         examType: json['examType']);
//   }
// }
