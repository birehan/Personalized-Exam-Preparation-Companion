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

  // this is for image cropper
  // Future<File?> _cropImage({required File imageFile}) async {
  //   CroppedFile? croppedImage = await ImageCropper().cropImage(
  //       compressFormat: ImageCompressFormat.png,
  //       sourcePath: imageFile.path,
  //       aspectRatio: const CropAspectRatio(
  //         ratioX: 1,
  //         ratioY: 1,
  //       ));
  //   if (croppedImage == null) {
  //     print('cropped image is null');
  //     return null;
  //   }
  //   return File(croppedImage.path);
  // }
}
