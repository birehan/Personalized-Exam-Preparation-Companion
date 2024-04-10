import 'package:hive_flutter/hive_flutter.dart';
import 'package:skill_bridge_mobile/core/constants/hive_boxes.dart';

class HiveBoxes {
  Future<void> initializeHive() async {
    await Hive.initFlutter();
    await Hive.openBox(homeBox);
    await Hive.openBox(courseBox);
    await Hive.openBox(profileBox);
    await Hive.openBox(examsbox);
    await Hive.openBox(mockBox);
    await Hive.openBox(quizBox);
    await Hive.openBox(contestBox);
  }

  Future<void> clearHiveBoxes() async {
    final List<String> boxNames = [
      homeBox,
      courseBox,
      profileBox,
      examsbox,
      mockBox,
      quizBox,
      contestBox,
    ];

    await Future.forEach(boxNames, (String boxName) async {
      var box = await Hive.openBox(boxName);
      await box.clear();
    });
    // await Hive.close();
  }
}
