import 'package:flutter/material.dart';
import 'package:medimed/Models/nurseadd.dart';
import 'package:medimed/Models/nursemodel.dart';
import 'package:medimed/Services/adminServices.dart';
import 'package:medimed/Services/nurseServices.dart';
import 'package:medimed/provider/nurseprovider.dart';
import 'package:provider/provider.dart';

class Adminprovider extends ChangeNotifier {
  Nursemodel? _nurseModel;
  NurseAdd? _adminAddModel;
  Nursemodel? get nurseModel => _nurseModel;
  NurseAdd? get adminAddModel => _adminAddModel;
  Future<void> getAllNurses() async {
    _nurseModel = await NurseServices.getAll();
    notifyListeners();
  }

  // Login Nurse
  Future<void> loginAdmin(String email, String pass) async
  {
    _adminAddModel = await Adminservices.login(email, pass);
    if(_adminAddModel != null)
    {
      notifyListeners();
    }
  }

  Future<void> updateNurse({
    required int nurseId,
    required bool approved,
    required String? message,
  }) async {
    await Adminservices.updateNurse(nurseId, approved, message);
    notifyListeners();
  }
}