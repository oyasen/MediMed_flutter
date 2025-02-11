import 'package:dio/dio.dart';
import 'package:medimed/Models/nursemodel.dart';

class Addpatient {
  static Dio dio = Dio();
  static signup(String firstName, String location, String lastName, String url, String email, int contact, String pass, String date, String gender) async {
    Response response = await dio.post('https://localhost:7047/api/Patients',
        data:  {
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          "password": pass,
          "dateOfBirth": date,
          "gender": gender,
          "contact": contact,
          "idCard": url,
          "location": location
        }
    );
    if (response.statusCode == 200) {
      return Nursemodel(Model: response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
}