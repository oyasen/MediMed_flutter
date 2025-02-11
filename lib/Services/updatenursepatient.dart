import 'package:dio/dio.dart';
import 'package:medimed/Models/nursemodel.dart';

class Updatenursepatient {
  static Dio dio = Dio();
  static updatePatient(int nurseId, int patientId, int price, String status) async {
    Response response = await dio.put('https://localhost:7047/api/Nurses/$nurseId/update-patient/$patientId?newPrice=$price&status=$status',
    );
    if (response.statusCode == 200) {
      return Nursemodel(Model: response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
}