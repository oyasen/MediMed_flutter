import 'package:flutter/material.dart';
import 'package:medimed/Models/nurseadd.dart';
import 'package:medimed/Models/nursemodel.dart';
import 'package:medimed/Services/nurseservices.dart'; // تأكد من استيراد الخدمة الصحيحة

class NurseProvider extends ChangeNotifier {
  NurseAdd? _nurseAddModel;
  Nursemodel? _nurseModel;

  NurseAdd? get nurseAddModel => _nurseAddModel;

  Nursemodel? get nurseModel => _nurseModel;

  // Add Nurse
  Future<void> addNurse({
    required String firstName,
    required String license,
    required String diploma,
    required String criminalRec,
    required String address,
    required String location,
    required String lastName,
    required String url,
    required String email,
    required int contact,
    required String pass,
  }) async {
    _nurseAddModel = await NurseServices.signup(
      firstName,
      license,
      diploma,
      criminalRec,
      address,
      location,
      lastName,
      url,
      email,
      contact,
      pass,
    );
    notifyListeners();
  }

  // Get Nurse by ID
  Future<void> getNurseById(int id) async {
    _nurseModel = await NurseServices.getById(id);
    notifyListeners();
  }

  // Get Nurse Patients
  Future<void> getNursePatients(int id) async {
    _nurseModel = await NurseServices.getPatients(id);
    notifyListeners();
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

  // Update Nurse
  Future<void> updateNurse({
    required int id,
    required String firstName,
    required String license,
    required String diploma,
    required String criminalRec,
    required String address,
    required String location,
    required String lastName,
    required String url,
    required String email,
    required int contact,
    required String pass,
  }) async {
    await NurseServices.update(
      id,
      firstName,
      license,
      diploma,
      criminalRec,
      address,
      location,
      lastName,
      url,
      email,
      contact,
      pass,
    );
    notifyListeners();
  }

  // Update Nurse Patient
  Future<void> updateNursePatient({
    required int nurseId,
    required int patientId,
    required int price,
    required String status,
  }) async {
    await NurseServices.updatePatient(nurseId, patientId, price, status);
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
}