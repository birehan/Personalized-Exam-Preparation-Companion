import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:skill_bridge_mobile/features/features.dart';

import '../../../../fixtures/fixture_reader.dart';

void main(){
  final upcomingContestModel = ContestModel(id: '6593b3b08a65e3bd7982fde9', title: 'Contest 2', description: 'First Contest', startsAt: DateTime.parse('2024-01-06T06:00:00.000Z'), endsAt: DateTime.parse('2024-01-06T06:30:00.000Z'), createdAt: DateTime.parse('2024-01-02T06:56:48.137Z'), live: true, hasRegistered: true, timeLeft: 120, liveRegister: 1, virtualRegister: 0,);

  test('should be a subclass of Contest entity.', () async { 
    // assert
    expect(upcomingContestModel, isA<Contest>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is received', () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('contest/contest.json'));
      // act
      final result = ContestModel.fromJson(jsonMap);  
      // assert
      expect(result, upcomingContestModel);
    });

    group('toJson', () { });
   });
}