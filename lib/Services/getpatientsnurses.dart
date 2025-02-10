import 'package:dio/dio.dart';
import 'package:medimed/Models/patientmodel.dart';

class Getpatientsnurses {
  static Dio dio = Dio();
  static getNurses(int patientId) async {
    Response response = await dio.get('https://localhost:7047/api/Patients/$patientId/nurses');
    if (response.statusCode == 200) {
      return PatientModel(Model: response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
}