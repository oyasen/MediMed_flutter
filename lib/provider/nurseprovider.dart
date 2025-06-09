import 'package:flutter/material.dart';
import 'package:medimed/Models/nurseadd.dart';
import 'package:medimed/Models/nursemodel.dart';
import 'package:medimed/Models/nursesmodel.dart';
import 'package:medimed/Models/patientsmodel.dart';
import 'package:medimed/Services/nurseservices.dart'; // تأكد من استيراد الخدمة الصحيحة

class NurseProvider extends ChangeNotifier {
  NurseAdd? _nurseAddModel;
  Nursemodel? _nurseModel;
  Nursegetmodel? _nurseGetModel;
  PatientsModel? _patientsModel;
  NurseAdd? get nurseAddModel => _nurseAddModel;

  Nursemodel? get nurseModel => _nurseModel;
  Nursegetmodel? get nurseGetModel => _nurseGetModel;
  PatientsModel? get patientsModel => _patientsModel;

  // Add Nurse
  Future<void> addNurse({
    required String fullName,
    required String email,
    required String password,
    required String contact,
    required String dob,
    required String gender,
    required String spec,
    required String location,
    required String prof,
    required String grad,
    required String idCard,
    required String pfp,
    required String crim,
  }) async {
    _nurseAddModel = await NurseServices.signup(fullName: fullName, email: email, password: password, contact: contact, grad: grad, crim: crim, idCard: idCard, prof: prof, spec : spec,dob: dob,gender: gender,location: location,pfp: pfp);
    notifyListeners();
  }

  // Get Nurse by ID
  Future<void> getNurseById(int id) async {
    _nurseGetModel = await NurseServices.getById(id);
    notifyListeners();
  }

  // Get Nurse Patients
  Future<void> getNursePatients(int id) async {
    try {
      _patientsModel = await NurseServices.getPatients(id);
      notifyListeners();
    } catch (e) {
      print("Error fetching patients: $e");
    }
  }

  // Get All Nurses
  Future<void> getAllNurses() async {
    _nurseModel = await NurseServices.getAll();
    notifyListeners();
  }

  // Login Nurse
  Future<void> loginNurse(String email, String pass) async {
    _nurseAddModel = await NurseServices.login(email, pass);
    notifyListeners();
  }
  Future<void> updateNurse({
    required int id,
    required String fullName,
    required String email,
    required String password,
    required String contact,
    required String dob,
    required String gender,
    required String spec,
    required String location,
    required String prof,
    required String grad,
    required String idCard,
    required String pfp,
    required String crim,
  }) async {
    await NurseServices.update(
      id: id,
      fullName: fullName,
      email: email,
      password: password,
      contact: contact,
      dob: dob,
      gender: gender,
      spec: spec,
      location: location,
      prof: prof,
      grad: grad,
      idCard: idCard,
      pfp: pfp,
      crim: crim,
    );
    notifyListeners();
  }

  // Update Nurse Patient
  Future<void> updateNursePatient({
    required int Id,
    required int price,
    required String status,
  }) async {
    await NurseServices.updatePatient(Id, price, status);
    notifyListeners();
  }

  // Delete Nurse
  Future<void> deleteNurse({required int id}) async {
    await NurseServices.delete(id); // استدعاء دالة الحذف من الخدمة
    notifyListeners();
  }

  Future<void> deleteNursePatient(
      { required int nurseId, required int patientId}) async {
    await NurseServices.deleteNurse(nurseId, patientId);
    notifyListeners();
  }
  Future<void> forgetPassword(String email, String pass) async {
    _nurseAddModel = await NurseServices.forget(email, pass);
    notifyListeners();
  }
}