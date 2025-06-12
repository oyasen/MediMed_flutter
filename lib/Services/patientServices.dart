import 'package:dio/dio.dart';
import 'package:medimed/Models/nursemodel.dart';
import 'package:medimed/Models/patientAdd.dart';
import 'package:medimed/Models/patientmodel.dart';
import 'package:medimed/Models/patientsmodel.dart';

class PatientServices
{
  static Dio dio = Dio();
  static signup({required String fullName,
    required String email,
    required String password,
    required String idCard,
    required String pfp,
    required String contact,
    required String dob,
    required String gender
  }) async {
    Response response = await dio.post('https://medimed.runasp.net/api/Patients',
        data:  {
          "fullName": fullName,
          "email": email,
          "password": password,
          "dateOfBirth": dob,
          "gender": gender,
          "contact": contact,
          "idCard": idCard,
          "personalPicture": pfp
        }
    );
    if (response.statusCode == 200) {
      return Patientadd.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static book(int nurseId, int patientId, String status) async {
    Response response = await dio.post('https://medimed.runasp.net/api/Patients/$patientId/assign-nurse/$nurseId?status=$status',
    );
    if (response.statusCode == 200) {
      return Patientadd.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static delete(int id) async {
    print("Attempting to delete patient with ID: $id");
    try {
      Response response = await dio.delete(
        'https://medimed.runasp.net/api/Patients/$id',
        options: Options(headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        }),
      );
      print("Delete response status code: ${response.statusCode}");
      print("Delete response data: ${response.data}");
      
      final statusCode = response.statusCode ?? 0;
      if (statusCode >= 200 && statusCode < 300) {
        print("Patient deleted successfully");
        return;
      } else {
        print("Delete failed with status code: $statusCode");
        throw Exception(response.statusMessage);
      }
    } catch (e) {
      print("Error deleting patient: $e");
      rethrow;
    }
  }
  static getById(int id) async {
    Response response = await dio.get('https://medimed.runasp.net/api/Patients/$id');
    if (response.statusCode == 200) {
      return PatientModel.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static getAll() async {
    Response response = await dio.get('https://medimed.runasp.net/api/Patients');
    if (response.statusCode == 200) {
      return PatientsModel.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static Future<Nursemodel> getNurses(int patientId) async {
    Response response = await dio.get(
        'https://medimed.runasp.net/api/Patients/$patientId/nurses');

    if (response.statusCode == 200 && response.data is List) {
      return Nursemodel.fromJson(response.data);
    } else {
      throw Exception("Failed to load nurses: ${response.statusMessage}");
    }
  }

  static login(String email,String pass) async {
    try
    {
      Response response = await dio.post('https://medimed.runasp.net/api/Patients/login',data: {
      "email": email,
      "password": pass
    });
    if (response.statusCode == 200) {
      return Patientadd.fromJson(response.data);
    } else {
      throw Exception(response.data["response"]);
    }

    }
    catch(ex){
      rethrow;
    }

  }
  static forget(String email,String pass) async {
    Response response = await dio.post('https://medimed.runasp.net/api/Patients/forget',data: {
      "email": email,
      "password":pass
    });
    if (response.statusCode == 200) {
      return Patientadd.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }

  static Future<void> update({
    required int id,
    required String fullname,
    required String email,
    required String password,
    required String dateOfBirth,
    required String gender,
    required String contact,
    required String imageUrl,
    required String pfp,
  }) async {
    try {
      Response response = await dio.put( // ✅ Changed from POST to PUT
        'https://medimed.runasp.net/api/Patients/$id',
        data: {
          "fullName": fullname,
          "email": email,
          "password": password,
          "dateOfBirth": dateOfBirth,
          "gender": gender,
          "contact": contact,
          "idCard": imageUrl,
          "personalPicture": pfp,
          "approved" : "Processing",
          "message" : ""
        },
        options: Options(headers: {
          "Content-Type": "application/json", // ✅ Ensure JSON format
          "Accept": "application/json",
          // "Authorization": "Bearer YOUR_ACCESS_TOKEN", // ✅ Add if required
        }),
      );

      if (response.statusCode == 202) {
        print("Patient updated successfully.");
      } else {
        throw Exception("Failed to update patient: ${response.statusMessage}");
      }
    } catch (e) {
      print("Error updating patient: $e");
      throw Exception("Failed to update patient.");
    }
  }


  static deletePatient(int nurseId, int patientId) async {
    Response response = await dio.delete('https://medimed.runasp.net/api/Patients/$patientId/remove-nurse/$nurseId',
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static updateNurse(int nurseId, int patientId, String status) async {
    Response response = await dio.put('https://medimed.runasp.net/api/Patients/$patientId/update-nurse/$nurseId?status=$status',);
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception(response.statusMessage);
    }
  }
}