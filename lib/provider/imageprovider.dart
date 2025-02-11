import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class UploadProvider extends ChangeNotifier
{
  final picker = ImagePicker();
  File? image;
  Future<File?> pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    notifyListeners();
  }
  Future<File?> pickImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    notifyListeners();
  }
  Future showOptions(context) async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text('Photo Gallery'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              pickImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Camera'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              pickImageFromCamera();
            },
          ),
        ],
      ),
    );
  }
  Future<String?> uploadImageToCloudinary() async {
    try {
      String cloudName = "dia0n1hla";
      String uploadPreset = "preset";  // Set in Cloudinary dashboard

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(image!.path),
        "upload_preset": uploadPreset,
      });

      var response = await Dio().post(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data["secure_url"]; // URL of the uploaded image
      } else {
        print("Upload failed: ${response.data}");
        return null;
      }
    } catch (e) {
      print("Error uploading: $e");
      return null;
    }
  }
}