import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploader {
  Future<File?> getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return null;
      final imageTemp = File(image.path);
      // final croppedImage = await _cropImage(imageFile: imageTemp);
      return imageTemp;
    } on PlatformException {
      print('platform dependent error eccured while taking picture');
    } catch (e) {
      print('unkown error ocured while uploading image => ${e.toString()}');
    }
    return null;
  }

}
