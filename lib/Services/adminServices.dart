import 'package:dio/dio.dart';
import 'package:medimed/Models/nurseadd.dart';
import 'package:medimed/Models/nursemodel.dart';
import 'package:medimed/Models/nursesmodel.dart';
import 'package:medimed/Models/patientsmodel.dart';

class Adminservices
{
  static Dio dio = Dio();
  static login(String email,String pass) async {
    Response response = await dio.post('https://medimed.runasp.net/api/Admins/login',
        data: {
          "email": email,
          "password": pass,
        }
    );
    if (response.statusCode == 200) {
      return NurseAdd(id: response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
  static updateNurse(int nurseId, bool approved, String? message) async {
    Response response = await dio.put('https://medimed.runasp.net/api/Admins/UpdateNurse/$nurseId?approved=$approved&message=$message',
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception(response.statusMessage);
    }
  }

}