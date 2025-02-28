import 'package:flutter/material.dart';
import 'package:medimed/Models/nurseadd.dart';
import 'package:medimed/Models/nursemodel.dart';
import 'package:medimed/Models/patientsmodel.dart';
import 'package:medimed/Services/adminServices.dart';
import 'package:medimed/Services/nurseServices.dart';
import 'package:medimed/Services/patientServices.dart';

class Adminprovider extends ChangeNotifier {
  PatientsModel? _patientsModel;
  Nursemodel? _nurseModel;
  NurseAdd? _adminAddModel;
  Nursemodel? get nurseModel => _nurseModel;
  PatientsModel? get patientsModel => _patientsModel;
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
    try {
      await Adminservices.updateNurse(nurseId, approved, message);
      print("Update successful for Nurse ID: $nurseId");

      // Find and update the nurse in the local list
      int index = nurseModel!.Model.indexWhere((nurse) => nurse["id"] == nurseId);
      if (index != -1) {
        nurseModel!.Model[index]["approved"] = approved;
        nurseModel!.Model[index]["message"] = message ?? "";
      }

      notifyListeners(); // Notify UI to update automatically
    } catch (e) {
      print("Error updating nurse: $e");
    }
  }

  Future<void> updatePatient({
    required int patientId,
    required bool approved,
    required String? message,
  }) async {
    await Adminservices.updatePatient(patientId, approved, message);
    print("Update successful for Nurse ID: $patientId");
    notifyListeners();
  }

  Future<void> getAllPatients() async {
    _patientsModel = await PatientServices.getAll();
    notifyListeners();
  }

}