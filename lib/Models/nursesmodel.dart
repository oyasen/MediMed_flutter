class Nursegetmodel {
  Map Model;
  Nursegetmodel({required this.Model});
  factory Nursegetmodel.fromJson(Map json) {
    return Nursegetmodel(Model: json);
  }
}