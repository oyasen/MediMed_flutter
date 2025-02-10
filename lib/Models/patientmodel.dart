import 'dart:convert';

class PatientModel {
  List<Map<dynamic,dynamic>> Model;
  PatientModel({required this.Model});
  factory PatientModel.fromJson(List<Map<dynamic,dynamic>> json) {
    return PatientModel(Model: json);
  }
}