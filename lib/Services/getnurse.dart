import 'package:dio/dio.dart';
import 'package:medimed/Models/nursemodel.dart';

class GetNurse {
  static Dio dio = Dio();
  static getAll() async {
    Response response = await dio.get('https://localhost:7047/api/Nurses');
    if (response.statusCode == 200) {
      return Nursemodel(Model: response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
}