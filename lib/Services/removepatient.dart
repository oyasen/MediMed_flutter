import 'package:dio/dio.dart';
import 'package:medimed/Models/nursemodel.dart';

class Removepatient {
  static Dio dio = Dio();
  static deletePatient(int nurseId, int patientId) async {
    Response response = await dio.delete('https://localhost:7047/api/Patients/$patientId/remove-nurse/$nurseId',
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception(response.statusMessage);
    }
  }
}