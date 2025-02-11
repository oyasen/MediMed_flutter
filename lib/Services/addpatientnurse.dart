import 'package:dio/dio.dart';
import 'package:medimed/Models/nursemodel.dart';

class Addpatientnurse {
  static Dio dio = Dio();
  static book(int nurseId, int patientId, String status) async {
    Response response = await dio.post('https://localhost:7047/api/Patients/$patientId/assign-nurse/$nurseId?status=$status',
    );
    if (response.statusCode == 200) {
      return Nursemodel(Model: response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
}