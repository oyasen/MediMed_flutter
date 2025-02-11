import 'package:dio/dio.dart';
import 'package:medimed/Models/patientmodel.dart';

class GetPatientById {
  static Dio dio = Dio();
  static getById(int id) async {
    Response response = await dio.get('https://localhost:7047/api/Patients/$id');
    if (response.statusCode == 200) {
      return PatientModel(Model: response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
}