import 'package:dio/dio.dart';
import 'package:medimed/Models/nurseadd.dart';
import 'package:medimed/Models/nursemodel.dart';
import 'package:medimed/Models/nursesmodel.dart';
import 'package:medimed/Models/patientsmodel.dart';

class NurseServices
{
  static Dio dio = Dio();
  static signup({
    required String fullName,
    required String email,
    required String password,
    required String contact,
    required String dob,
    required String gender,
    required String spec,
    required String location,
    required String prof,
    required String grad,
    required String idCard,
    required String pfp,
    required String crim,
  }) async {
    Response response = await dio.post('https://medimed.runasp.net/api/Nurses',
        data:  {
          "fullName": fullName,
          "email": email,
          "password": password,
          "contact": contact,
          "dateOfBirth": dob,
          "gender": gender,
          "specialaization": spec,
          "location": location,
          "professionalPracticeLicense": prof,
          "graduationCertificate": grad,
          "idCard": idCard,
          "personalPicture": pfp,
          "criminalRecordAndIdentification": crim,
        }
    );
    if (response.statusCode == 200) {
      return NurseAdd.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static delete(int id) async {
    Response response = await dio.delete('https://medimed.runasp.net/api/Nurses/$id');
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static getAll() async {
    Response response = await dio.get('https://medimed.runasp.net/api/Nurses');
    if (response.statusCode == 200) {
      return Nursemodel.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static getById(int id) async {
    Response response = await dio.get('https://medimed.runasp.net/api/Nurses/$id');
    if (response.statusCode == 200) {
      return Nursegetmodel.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static getPatients(int nurseId) async {
    Response response = await dio.get('https://medimed.runasp.net/api/Nurses/$nurseId/patients');
    print("Response Data: ${response.data}"); // Debugging
    if (response.statusCode == 200) {
      return PatientsModel.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static login(String email,String pass) async {
    Response response = await dio.post('https://medimed.runasp.net/api/Nurses/login',
        data: {
          "email": email,
          "password": pass,
        }
    );
    if (response.statusCode == 200) {
      return NurseAdd(id: response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }static Future<void> update({
    required int id,
    required String fullName,
    required String email,
    required String password,
    required String contact,
    required String dob,
    required String gender,
    required String spec,
    required String location,
    required String prof,
    required String grad,
    required String idCard,
    required String pfp,
    required String crim,
  }) async {
    try {
      Response response = await dio.put(
        'https://medimed.runasp.net/api/Nurses/$id',
        data: {
          "fullName": fullName,
          "email": email,
          "password": password,
          "contact": contact,
          "dateOfBirth": dob,
          "gender": gender,
          "specialaization": spec,
          "location": location,
          "professionalPracticeLicense": prof,
          "graduationCertificate": grad,
          "idCard": idCard,
          "personalPicture": pfp,
          "criminalRecordAndIdentification": crim,
          "approved": "Processing",
          "message": ""
        },
        options: Options(
          headers: {"Content-Type": "application/json"}, // Ensure correct content type
          validateStatus: (status) {
            return status! < 500; // Allow errors below 500 for debugging
          },
        ),
      );

      if (response.statusCode == 202) {
        return;
      } else {
        throw Exception(
            "Failed to update profile: ${response.statusCode} - ${response.data}");
      }
    } catch (e) {
      print("Error updating nurse: $e");
      throw Exception("An error occurred while updating the profile.");
    }
  }

  static deleteNurse(int nurseId, int patientId) async {
    Response response = await dio.delete('https://medimed.runasp.net/api/Nurses/$nurseId/remove-patient/$patientId',
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static updatePatient(int nurseId, int patientId, int price, String status) async {
    Response response = await dio.put('https://medimed.runasp.net/api/Nurses/$nurseId/update-patient/$patientId?newPrice=$price&status=$status',
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static forget(String email,String pass) async {
    Response response = await dio.post('https://medimed.runasp.net/api/Nurses/forget',data: {
      "email": email,
      "password":pass
    });
    if (response.statusCode == 200) {
      return NurseAdd.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
}