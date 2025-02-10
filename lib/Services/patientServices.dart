import 'package:dio/dio.dart';
import 'package:medimed/Models/nursemodel.dart';
import 'package:medimed/Models/patientmodel.dart';

class PatientServices
{
  static Dio dio = Dio();
  static signup(String firstName, String location, String lastName, String url, String email, int contact, String pass, String date, String gender) async {
    Response response = await dio.post('https://localhost:7047/api/Patients',
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
      return PatientModel(Model: response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static book(int nurseId, int patientId, String status) async {
    Response response = await dio.post('https://localhost:7047/api/Patients/$patientId/assign-nurse/$nurseId?status=$status',
    );
    if (response.statusCode == 200) {
      return PatientModel(Model: response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static delete(int id) async {
    Response response = await dio.delete('https://localhost:7047/api/Patients/$id',
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static getById(int id) async {
    Response response = await dio.get('https://localhost:7047/api/Patients/$id');
    if (response.statusCode == 200) {
      return PatientModel(Model: response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static getAll() async {
    Response response = await dio.get('https://localhost:7047/api/Patients');
    if (response.statusCode == 200) {
      return PatientModel(Model: response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static getNurses(int patientId) async {
    Response response = await dio.get('https://localhost:7047/api/Patients/$patientId/nurses');
    if (response.statusCode == 200) {
      return Nursemodel(Model: response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static login(String email,String pass) async {
    Response response = await dio.post('https://localhost:7047/api/Patients/login',
        data:  {
          "email": email,
          "password": pass,
        }
    );
    if (response.statusCode == 200) {
      return PatientModel(Model: response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static update(int id, String firstName, String location, String lastName, String url, String email, int contact, String pass, String date, String gender) async {
    Response response = await dio.post('https://localhost:7047/api/Patients/$id',
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
    Response response = await dio.delete('https://localhost:7047/api/Patients/$patientId/remove-nurse/$nurseId',
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static updateNurse(int nurseId, int patientId, String status) async {
    Response response = await dio.put('https://localhost:7047/api/Patients/$patientId/update-nurse/$nurseId?status=$status',
    );
    if (response.statusCode == 200) {
      return PatientModel(Model: response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
}