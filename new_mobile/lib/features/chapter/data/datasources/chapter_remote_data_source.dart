import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/app_keys.dart';
import '../../../../core/core.dart';
import '../../../features.dart';
import '../../domain/entities/sub_chapters_entity.dart';
import '../models/sub_chapters_model.dart';

abstract class ChapterRemoteDatasource {
  Future<List<Chapter>> allChapters(String courseId);
  Future<SubChapter> loadContent(String subChapterId);
  Future<SubChapters> loadSubChapters(String chapterId);
  Future<List<Chapter>> getChaptersByCourseId(String courseId);
}

class ChapterRemoteDataSourceImpl extends ChapterRemoteDatasource {
  final http.Client client;
  final FlutterSecureStorage flutterSecureStorage;

  ChapterRemoteDataSourceImpl(
      {required this.flutterSecureStorage, required this.client});

  @override
  Future<List<Chapter>> allChapters(String courseId) {
    // TODO: implement allChapters
    throw UnimplementedError();
  }

  @override
  Future<SubChapter> loadContent(String subChapterId) async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];
    try {
      print(subChapterId);
      final response = await client.get(
        Uri.parse('$baseUrl/sub-chapter/content/$subChapterId'),
        headers: {
          'content-Type': 'application/json',
          'authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        dynamic subChapterJson = data['subChapter'];

        SubChapter subChapter = SubChapterModel.fromJson(subChapterJson);

        return subChapter;
      } else if (response.statusCode == 429) {
        throw RequestOverloadException(errorMessage: 'Too Many Request');
      } else {
        throw ServerException();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SubChapters> loadSubChapters(String chapterId) async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/sub-chapter/$chapterId'),
        headers: {
          'content-Type': 'application/json',
          'authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];

        SubChaptersModel subChapterModel = SubChaptersModel.fromJson(data);

        return subChapterModel;
      } else if (response.statusCode == 429) {
        throw RequestOverloadException(errorMessage: 'Too Many Request');
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<Chapter>> getChaptersByCourseId(String courseId) async {
    final userCredential =
        await flutterSecureStorage.read(key: authenticationKey);

    if (userCredential == null) {
      throw UnauthorizedRequestException();
    }

    final token = json.decode(userCredential)['token'];

    final response = await client.get(
      Uri.parse('$baseUrl/chapter/courseChapters/$courseId'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data']['chapters'];

      return data
          .map<ChapterModel>(
            (chapter) => ChapterModel.fromJson(chapter),
          )
          .toList();
    } else if (response.statusCode == 429) {
      throw RequestOverloadException(errorMessage: 'Too Many Request');
    }
    throw ServerException();
  }
}
