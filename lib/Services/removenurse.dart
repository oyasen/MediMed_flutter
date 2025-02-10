import 'package:dio/dio.dart';
import 'package:medimed/Models/nursemodel.dart';

class Removenurse {
  static Dio dio = Dio();
  static deleteNurse(int nurseId, int patientId) async {
    Response response = await dio.delete('https://localhost:7047/api/Nurses/$nurseId/remove-patient/$patientId',
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception(response.statusMessage);
    }
  }
}