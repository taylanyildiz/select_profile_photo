import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class UtilsImage {
  static Future<File> mediaPicker({
    @required bool isGallery,
    @required Function(File file) croppImage,
  }) async {
    final source = isGallery ? ImageSource.gallery : ImageSource.camera;
    final pickerImage = await ImagePicker().getImage(source: source);
    if (pickerImage == null) return null;
    if (croppImage == null)
      return File(pickerImage.path);
    else
      return croppImage(File(pickerImage.path));
  }
}
