import '../../../features.dart';

class ContestPrizeModel extends ContestPrize {
  const ContestPrizeModel(
      {required super.description,
      required super.standing,
      required super.type,
      required super.amount,
      required super.id});

  factory ContestPrizeModel.fromJson(Map<String, dynamic> json) {
    int amount = json['amount'] ?? 0;
    double doubleVal = amount.toDouble();
    return ContestPrizeModel(
      description: json['description'] ?? '',
      standing: json['standing'] ?? 0,
      type: json['type'] ?? '',
      amount: doubleVal,
      id: json['_id'],
    );
  }
}
