import 'package:dio/dio.dart';
import 'package:medimed/Models/nurseadd.dart';

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
  static Future<void> updatePatient(int patientId, bool approved, String? message) async {
    try {
      Response response = await dio.put(
        'https://medimed.runasp.net/api/Admins/UpdatePatient/$patientId?approved=${approved ? 'true' : 'false'}&message=$message',
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 202) {
        print("Patient update successful.");
      } else {
        throw Exception("Unexpected response: ${response.statusCode} - ${response.statusMessage}");
      }
    } catch (e) {
      print("Error updating patient: $e");
      throw Exception("An error occurred while updating the patient.");
    }
  }

}