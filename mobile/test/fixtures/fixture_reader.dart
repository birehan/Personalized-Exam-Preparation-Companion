import 'dart:io';

String fixture(String name) => File('test/fixtures/$name').readAsStringSync();
Future<String?> fixtureFutures(String name) async =>
    File('test/fixtures/$name').readAsStringSync();
