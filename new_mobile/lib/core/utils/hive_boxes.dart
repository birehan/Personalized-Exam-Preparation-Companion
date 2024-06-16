import 'package:hive_flutter/hive_flutter.dart';

import '../core.dart';

class HiveBoxes {
  Future<void> initializeHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(SetStringAdapter());
    await Hive.openBox(homeBox);
    await Hive.openBox(courseBox);
    await Hive.openBox(profileBox);
    await Hive.openBox(examsbox);
    await Hive.openBox(mockBox);
    await Hive.openBox(quizBox);
    await Hive.openBox(contestBox);
    await Hive.openBox(offlineCoursesBox);
    await Hive.openBox(downloadedCoursesBox);
    await Hive.openBox(offlineMocksBox);
    await Hive.openBox(downloadedMocksBox);
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
      offlineCoursesBox,
      downloadedCoursesBox,
      offlineMocksBox,
      downloadedMocksBox,
    ];

    await Future.forEach(boxNames, (String boxName) async {
      var box = await Hive.openBox(boxName);
      await box.clear();
    });
    // await Hive.close();
  }
}
