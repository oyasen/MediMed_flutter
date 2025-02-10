import 'package:dio/dio.dart';
import 'package:medimed/Models/nursemodel.dart';

class GetNurseById {
  static Dio dio = Dio();
  static getById(int id) async {
    Response response = await dio.get('https://localhost:7047/api/Nurses/$id');
    if (response.statusCode == 200) {
      return Nursemodel(Model: response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
}