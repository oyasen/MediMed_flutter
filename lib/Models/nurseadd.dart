class NurseAdd {
  var id;
  NurseAdd({required this.id});
  factory NurseAdd.fromJson(var id) {
    return NurseAdd(id:id);
  }
}