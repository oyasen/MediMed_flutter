class PatientsModel {
  List<Map<String, dynamic>> Model;

  PatientsModel({required this.Model});

  factory PatientsModel.fromJson(List<dynamic> json) {
    return PatientsModel(Model: List<Map<String, dynamic>>.from(json));
  }
}