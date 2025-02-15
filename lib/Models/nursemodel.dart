class Nursemodel {
  List Model;
  Nursemodel({required this.Model});
  factory Nursemodel.fromJson(List json) {
    return Nursemodel(Model: json);
  }
}