import 'package:flutter/material.dart';
import 'package:medimed/Models/patientAdd.dart';
import 'package:medimed/Models/patientmodel.dart';
import 'package:medimed/Services/nurseServices.dart';
import 'package:medimed/Services/patientServices.dart';

class NurseProvider extends ChangeNotifier {
  Patientadd? _nurseAddModel;
  PatientModel? _nurseModel;

  Patientadd? get nurseAddModel => _nurseAddModel;
  PatientModel? get nurseModel => _nurseModel;

  // Add Nurse
  Future<void> addNurse({
    required String firstName,
    required String lastName,
    required String url,
    required String email,
    required String pass,
    required int contact,
    required String date,
    required String gender,
    required String location,
  }) async {
    _nurseAddModel = await PatientServices.signup(
      firstName,
      lastName,
      email,
      pass,
      url,
      contact,
      date,
      gender,
      location,
    );
    notifyListeners();
  }

  // Get Nurse by ID
  Future<void> getNurseById(int id) async {
    _nurseModel = await PatientServices.getById(id);
    notifyListeners();
  }

  // Get Nurse Patients
  Future<void> getNursePatients(int id) async {
    _nurseModel = await PatientServices.getNurses(id);
    notifyListeners();
  }

  // Get All Nurses
  Future<void> getAllNurses() async {
    _nurseModel = await PatientServices.getAll();
    notifyListeners();
  }

  // Login Nurse
  Future<void> loginNurse(String email, String pass) async {
    _nurseAddModel = await PatientServices.login(email, pass);
    notifyListeners();
  }

  // Update Nurse
  Future<void> updateNurse({
    required int id,
    required String firstName,
    required String lastName,
    required String url,
    required String email,
    required String pass,
    required int contact,
    required String date,
    required String gender,
    required String location,
  }) async {
    await PatientServices.update(
      id,
      firstName,
      lastName,
      email,
      pass,
      url,
      contact,
      date,
      gender,
      location,
    );
    notifyListeners();
  }

  // Update Nurse Patient
  Future<void> updateNursePatient({
    required int nurseId,
    required int patientId,
    required String status,
  }) async {
    await PatientServices.updateNurse(nurseId, patientId, status);
    notifyListeners();
  }

  Future<void> deleteNurse({required int id}) async {
    await PatientServices.delete(id); // استدعاء دالة الحذف من الخدمة
    notifyListeners();
  }

  Future<void> deleteNursePatient(
      { required int nurseId, required int patientId}) async {
    await PatientServices.deletePatient(nurseId, patientId);
    notifyListeners();
  }
}