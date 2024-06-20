import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

Future<XFile?> pickImage(ImageSource source, String aspectRatio) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: source, imageQuality: 50);

  CroppedFile? croppedFile = await ImageCropper().cropImage(
    sourcePath: file!.path,
    aspectRatio: CropAspectRatio(
        ratioX: double.parse(aspectRatio.split('/')[0]),
        ratioY: double.parse(aspectRatio.split('/')[1])),
    compressFormat: ImageCompressFormat.jpg,
    compressQuality: 95,
    uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true),
      IOSUiSettings(
        aspectRatioLockEnabled: true,
        resetAspectRatioEnabled: false,
        aspectRatioPresets: [CropAspectRatioPreset.ratio5x4],
        title: 'Cropper',
      ),
    ],
  );

  if (croppedFile != null) {
    return XFile(croppedFile.path, mimeType: "image/jpg");
  }
  return null;
}
