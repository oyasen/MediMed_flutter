import 'package:dio/dio.dart';
import 'package:medimed/Models/nursemodel.dart';

class Addnurse {
  static Dio dio = Dio();
  static signup(String firstName, String license, String diploma, String criminalRec, String address, String location, String lastName, String url, String email, int contact, String pass) async {
    Response response = await dio.post('https://localhost:7047/api/Nurses',
        data:  {
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          "password": pass,
          "licenseNumber": license,
          "contact": contact,
          "professionalPracticeLicense": license,
          "graduationCertificate": diploma,
          "idCard": url,
          "criminalRecordAndIdentification": criminalRec,
          "address": address,
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