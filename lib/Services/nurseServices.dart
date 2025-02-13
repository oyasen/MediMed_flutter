import 'package:dio/dio.dart';
import 'package:medimed/Models/nurseadd.dart';
import 'package:medimed/Models/nursemodel.dart';
import 'package:medimed/Models/patientmodel.dart';

class NurseServices
{
  static Dio dio = Dio();
  static signup({required String fullName,required String email,required String pass,required String contact,required String grad,required String criminalRec,required String idCard,required String prof,}) async {
    Response response = await dio.post('http://medimed.runasp.net/api/Nurses',
        data:  {
          "fullName": fullName,
          "email": email,
          "password": pass,
          "contact": contact,
          "professionalPracticeLicense": prof,
          "graduationCertificate": grad,
          "idCard": idCard,
          "criminalRecordAndIdentification": criminalRec
        }
    );
    if (response.statusCode == 200) {
      return NurseAdd.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static delete(int id) async {
    Response response = await dio.delete('http://medimed.runasp.net/api/Nurses/$id');
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static getAll() async {
    Response response = await dio.get('http://medimed.runasp.net/api/Nurses');
    if (response.statusCode == 200) {
      return Nursemodel.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static getById(int id) async {
    Response response = await dio.get('http://medimed.runasp.net/api/Nurses/$id');
    if (response.statusCode == 200) {
      return Nursemodel.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static getPatients(int nurseId) async {
    Response response = await dio.get('http://medimed.runasp.net/api/Nurses/$nurseId/patients');
    if (response.statusCode == 200) {
      return PatientModel.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static login(String email,String pass) async {
    Response response = await dio.post('http://medimed.runasp.net/api/Nurses/login',
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
  }
  static update(int id, String firstName, String license, String diploma, String criminalRec, String address, String location, String lastName, String url, String email, int contact, String pass) async {
    Response response = await dio.post('http://medimed.runasp.net/api/Nurses/$id',
        data:  {
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          "password": pass,
          "licenseNumber": license,
          "contact": contact,
          "professionalPracticeLicense": license,
          "graduationCertificate": diploma,
          "idCard": url,
          "criminalRecordAndIdentification": criminalRec,
          "address": address,
          "location": location
        }
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static deleteNurse(int nurseId, int patientId) async {
    Response response = await dio.delete('http://medimed.runasp.net/api/Nurses/$nurseId/remove-patient/$patientId',
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static updatePatient(int nurseId, int patientId, int price, String status) async {
    Response response = await dio.put('http://medimed.runasp.net/api/Nurses/$nurseId/update-patient/$patientId?newPrice=$price&status=$status',
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception(response.statusMessage);
    }
  }
}