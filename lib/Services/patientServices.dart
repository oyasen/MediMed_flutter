import 'package:dio/dio.dart';
import 'package:medimed/Models/nursemodel.dart';
import 'package:medimed/Models/patientAdd.dart';
import 'package:medimed/Models/patientmodel.dart';

class PatientServices
{
  static Dio dio = Dio();
  static signup(String firstName,  String lastName,  String email, String pass, String url,  int contact,  String date, String gender, String location,) async {
    Response response = await dio.post('http://medimed.runasp.net/api/Patients',
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
      return Patientadd.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static book(int nurseId, int patientId, String status) async {
    Response response = await dio.post('http://medimed.runasp.net/api/Patients/$patientId/assign-nurse/$nurseId?status=$status',
    );
    if (response.statusCode == 200) {
      return Patientadd.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static delete(int id) async {
    Response response = await dio.delete('http://medimed.runasp.net/api/Patients/$id',
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static getById(int id) async {
    Response response = await dio.get('http://medimed.runasp.net/api/Patients/$id');
    if (response.statusCode == 200) {
      return PatientModel.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static getAll() async {
    Response response = await dio.get('http://medimed.runasp.net/api/Patients');
    if (response.statusCode == 200) {
      return PatientModel.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static getNurses(int patientId) async {
    Response response = await dio.get('http://medimed.runasp.net/api/Patients/$patientId/nurses');
    if (response.statusCode == 200) {
      return PatientModel.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static login(String email,String pass) async {
    Response response = await dio.post('http://medimed.runasp.net/api/Patients/login?email=$email&password=$pass',
        data:  {
          "email": email,
          "password": pass,
        }
    );
    if (response.statusCode == 200) {
      return Patientadd.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static update(int id, String firstName, String location, String lastName, String url, String email, int contact, String pass, String date, String gender) async {
    Response response = await dio.post('http://medimed.runasp.net/api/Patients/$id',
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
    Response response = await dio.delete('http://medimed.runasp.net/api/Patients/$patientId/remove-nurse/$nurseId',
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static updateNurse(int nurseId, int patientId, String status) async {
    Response response = await dio.put('http://medimed.runasp.net/api/Patients/$patientId/update-nurse/$nurseId?status=$status',
    );
    if (response.statusCode == 200) {
      return PatientModel(Model: response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
}