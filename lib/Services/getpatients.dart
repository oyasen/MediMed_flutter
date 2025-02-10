import 'package:dio/dio.dart';
import 'package:medimed/Models/patientmodel.dart';

class Getpatients {
  static Dio dio = Dio();
  static getAll() async {
    Response response = await dio.get('https://localhost:7047/api/Patients');
    if (response.statusCode == 200) {
      return PatientModel(Model: response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
}