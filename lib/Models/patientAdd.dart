class Patientadd {
  int id;
  Patientadd({required this.id});
  factory Patientadd.fromJson(int id) {
    return Patientadd(id:id);
  }
}