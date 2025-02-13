class PatientsModel
{
  List<Map<dynamic,dynamic>> Model;
  PatientsModel({required this.Model});
  factory PatientsModel.fromJson(List<Map<dynamic,dynamic>> json) {
    return PatientsModel(Model: json);
  }
}