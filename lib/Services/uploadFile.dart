import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}
Future<String?> uploadImageToCloudinary(File imageFile) async {
  try {
    String cloudName = "dia0n1hla";
    String uploadPreset = "preset";  // Set in Cloudinary dashboard

    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(imageFile.path),
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
/*
import 'package:flutter/material.dart';
import 'dart:io';

class CloudinaryUploader extends StatefulWidget {
  @override
  _CloudinaryUploaderState createState() => _CloudinaryUploaderState();
}

class _CloudinaryUploaderState extends State<CloudinaryUploader> {
  File? _image;
  String? _imageUrl;

  Future<void> pickAndUploadImage() async {
    File? pickedImage = await pickImage();
    if (pickedImage == null) return;

    setState(() {
      _image = pickedImage;
    });

    String? url = await uploadImageToCloudinary(pickedImage);
    if (url != null) {
      setState(() {
        _imageUrl = url;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload to Cloudinary")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? Image.file(_image!, width: 150, height: 150, fit: BoxFit.cover)
                : Icon(Icons.image, size: 100),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickAndUploadImage,
              child: Text("Pick & Upload Image"),
            ),
            SizedBox(height: 20),
            _imageUrl != null
                ? Image.network(_imageUrl!, width: 150, height: 150, fit: BoxFit.cover)
                : Container(),
          ],
        ),
      ),
    );
  }
}

 */