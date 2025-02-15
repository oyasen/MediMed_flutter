class PatientModel {
  Map<dynamic,dynamic> Model;
  PatientModel({required this.Model});
  factory PatientModel.fromJson(Map<dynamic,dynamic> json) {
    return PatientModel(Model: json);
  }
}