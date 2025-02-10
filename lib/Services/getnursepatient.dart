import 'package:dio/dio.dart';
import 'package:medimed/Models/nursemodel.dart';

class Getnursepatient {
  static Dio dio = Dio();
  static getPatients(int nurseId) async {
    Response response = await dio.get('https://localhost:7047/api/Nurses/$nurseId/patients');
    if (response.statusCode == 200) {
      return Nursemodel(Model: response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
}