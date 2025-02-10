class Nursemodel {
  List<Map<dynamic,dynamic>> Model;
  Nursemodel({required this.Model});
  factory Nursemodel.fromJson(List<Map<dynamic,dynamic>> json) {
    return Nursemodel(Model: json);
  }
}