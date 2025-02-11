import 'package:dio/dio.dart';
import 'package:medimed/Models/nursemodel.dart';

class LoginNurse {
  static Dio dio = Dio();
  static login(String email,String pass) async {
    Response response = await dio.post('https://localhost:7047/api/Nurses/login',
        data:  {
          "email": email,
          "password": pass,
        }
    );
    if (response.statusCode == 200) {
      return Nursemodel(Model: response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
}