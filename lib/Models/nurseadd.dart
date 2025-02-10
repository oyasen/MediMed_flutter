class NurseAdd {
  int id;
  NurseAdd({required this.id});
  factory NurseAdd.fromJson(int id) {
    return NurseAdd(id:id);
  }
}