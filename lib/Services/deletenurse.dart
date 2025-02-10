import 'package:dio/dio.dart';
import 'package:medimed/Models/nursemodel.dart';

class Deletenurse {
  static Dio dio = Dio();
  static getAll(int id) async {
    Response response = await dio.post('https://localhost:7047/api/Nurses/$id',
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception(response.statusMessage);
    }
  }
}