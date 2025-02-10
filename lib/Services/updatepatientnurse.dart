import 'package:dio/dio.dart';
import 'package:medimed/Models/nursemodel.dart';

class Updatepatientnurse {
  static Dio dio = Dio();
  static updateNurse(int nurseId, int patientId, String status) async {
    Response response = await dio.put('https://localhost:7047/api/Patients/$patientId/update-nurse/$nurseId?status=$status',
    );
    if (response.statusCode == 200) {
      return Nursemodel(Model: response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
}