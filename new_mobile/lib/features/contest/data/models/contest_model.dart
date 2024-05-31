import '../../../features.dart';

class ContestModel extends Contest {
  const ContestModel({
    required super.id,
    required super.title,
    required super.description,
    required super.startsAt,
    required super.endsAt,
    required super.createdAt,
    required super.live,
    required super.hasRegistered,
    required super.timeLeft,
    required super.liveRegister,
    required super.virtualRegister,
  });

  factory ContestModel.fromJson(Map<String, dynamic> json) {
    return ContestModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      startsAt: json['startsAt'] == null
          ? DateTime.now()
          : DateTime.parse(json['startsAt']),
      // : DateTime.now().add(const Duration(seconds: 5)),
      endsAt: json['endsAt'] == null
          ? DateTime.now()
          : DateTime.parse(json['endsAt']),
      createdAt: json['createdAt'] == null
          ? DateTime.now()
          : DateTime.parse(json['createdAt']),
      live: json['live'] ?? false,
      hasRegistered: json['hasRegistered'] ?? false,
      timeLeft: (json['timeLeft'] ?? 0).toInt(),
      liveRegister: json['liveRegister'] ?? 0,
      virtualRegister: json['virtualRegister'] ?? 0,
    );
  }
}
