import 'package:dio/dio.dart';
import 'package:medimed/Models/nursemodel.dart';
import 'package:medimed/Models/patientAdd.dart';
import 'package:medimed/Models/patientmodel.dart';

class PatientServices
{
  static Dio dio = Dio();
  static signup({required String fullName,required String email,required String pass,required String url,required String contact,required  String date,required String gender}) async {
    Response response = await dio.post('https://medimed.runasp.net/api/Patients',
        data:  {
          "fullName": fullName,
          "email": email,
          "password": pass,
          "dateOfBirth": date,
          "gender": gender,
          "contact": contact,
          "idCard": url
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
    Response response = await dio.delete('https://medimed.runasp.net/api/Patients/$id',
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception(response.statusMessage);
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
      return PatientModel.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static getNurses(int patientId) async {
    Response response = await dio.get('https://medimed.runasp.net/api/Patients/$patientId/nurses');
    if (response.statusCode == 200) {
      return Nursemodel.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
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

  static update(int id, String firstName, String location, String lastName, String url, String email, int contact, String pass, String date, String gender) async {
    Response response = await dio.post('https://medimed.runasp.net/api/Patients/$id',
        data:  {
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          "password": pass,
          "dateOfBirth": date,
          "gender": gender,
          "contact": contact,
          "idCard": url,
          "location": location
        }
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception(response.statusMessage);
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
    Response response = await dio.put('https://medimed.runasp.net/api/Patients/$patientId/update-nurse/$nurseId?status=$status',
    );
    if (response.statusCode == 200) {
      return PatientModel(Model: response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
}