import 'package:dio/dio.dart';
import 'package:medimed/Models/nursemodel.dart';

class Deletepatient {
  static Dio dio = Dio();
  static delete(int id) async {
    Response response = await dio.delete('https://localhost:7047/api/Patients/$id',
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception(response.statusMessage);
    }
  }
}