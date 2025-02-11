import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class UploadProvider extends ChangeNotifier {
  final picker = ImagePicker();
  File? _selectedImage;

  File? get selectedImage => _selectedImage;

  Future<File?> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      notifyListeners();
      return _selectedImage;
    }
    return null;
  }

  Future<File?> pickImageFromGallery() => _pickImage(ImageSource.gallery);
  Future<File?> pickImageFromCamera() => _pickImage(ImageSource.camera);

  Future<File?> showOptions(BuildContext context) async {
    return await showCupertinoModalPopup<File?>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text('Photo Gallery'),
            onPressed: () async {
              Navigator.of(context).pop(await pickImageFromGallery());
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Camera'),
            onPressed: () async {
              Navigator.of(context).pop(await pickImageFromCamera());
            },
          ),
        ],
      ),
    );
  }

  Future<String?> uploadImageToCloudinary(File? image) async {
    if (image == null) return null; // Prevent null reference

    try {
      String cloudName = "dia0n1hla";
      String uploadPreset = "preset";

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(image.path),
        "upload_preset": uploadPreset,
        "folder": "Photos",
      });

      var response = await Dio().post(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data["secure_url"];
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
