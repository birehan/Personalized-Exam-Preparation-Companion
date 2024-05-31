import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../../../core/core.dart';

import '../../../../core/constants/app_keys.dart';
import '../../../features.dart';

abstract class DepartmentRemoteDatasource {
  Future<List<GeneralDepartment>> getAllDepartments();
}

class DepartmentRemoteDatasourceImpl extends DepartmentRemoteDatasource {
  final http.Client client;

  DepartmentRemoteDatasourceImpl({
    required this.client,
  });

  @override
  Future<List<GeneralDepartment>> getAllDepartments() async {
    final response = await client.get(
      Uri.parse('$baseUrl/generalDepartment'),
      headers: {
        'Content-Type': 'application/json',
        'autorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJfaWQiOiI2NDk1NGMxNTU1NDRkNTVlMGNmNjc0Y2QiLCJlbWFpbCI6ImRhbmllbHRlZmVyYTIyMTFAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoic3RyaW5nIiwibGFzdE5hbWUiOiJzdHJpbmciLCJwYXNzd29yZCI6IiQyYiQxMCRHN3FBM0c5a0szWllIUGFVcGtFOFZPdnpYdnh3bFpQVTFyWlNkSlVHT3QwTzFERmcxbEhkTyIsImRlcGFydG1lbnQiOiJzdHJpbmciLCJyZXNldFRva2VuIjoiIiwiY3JlYXRlZEF0IjoiMjAyMy0wNi0yM1QwNzozOTowMS45NzhaIiwidXBkYXRlZEF0IjoiMjAyMy0wNi0yM1QwNzozOTowMS45NzhaIiwiX192IjowfSwiaWF0IjoxNjg3Nzg2MDIwLCJleHAiOjE2OTAzNzgwMjB9.AOLazU8_f-qGEHYSMURP9CIUahooKZeeoZA5dgORDY0'
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data']['generalDepartments'];
      return data
          .map<GeneralDepartment>((generalDepartment) =>
              GeneralDepartmentModel.fromJson(generalDepartment))
          .toList();
    } else if (response.statusCode == 429) {
      throw RequestOverloadException(errorMessage: 'Too Many Request');
    }
    throw ServerException();
  }
}
