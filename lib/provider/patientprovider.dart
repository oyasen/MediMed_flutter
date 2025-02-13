import 'package:flutter/material.dart';
import 'package:medimed/Models/nursemodel.dart';
import 'package:medimed/Models/patientAdd.dart';
import 'package:medimed/Models/patientmodel.dart';
import 'package:medimed/Models/patientsmodel.dart';
import 'package:medimed/Services/nurseServices.dart';
import 'package:medimed/Services/patientServices.dart';

class PatientProvider extends ChangeNotifier {
  Patientadd? _patientAddModel;
  PatientModel? _patientModel;
  PatientsModel? _patientsModel;
  Nursemodel? _nurseModel;

  Patientadd? get patientAddModel => _patientAddModel;
  PatientModel? get patientModel => _patientModel;
  Nursemodel? get nurseModel => _nurseModel;
  PatientsModel? get patientsModel => _patientsModel;

  // Add Nurse
  Future<void> addPatient({
    required String fullName,
    required String url,
    required String email,
    required String pass,
    required String contact,
    required String date,
    required String gender,
  }) async {
    _patientAddModel = await PatientServices.signup(
      fullName: fullName,
      email: email,
      pass: pass,
      url: url,
      contact: contact,
      date: date,
      gender: gender
    );
    notifyListeners();
  }

  // Get Nurse by ID
  Future<void> getPatientById(int id) async {
    _patientModel = await PatientServices.getById(id);
    notifyListeners();
  }

  // Get Nurse Patients
  Future<void> getPatientsNurse(int id) async {
    _nurseModel = await PatientServices.getNurses(id);
    notifyListeners();
  }

  // Get All Nurses
  Future<void> getAllPatient() async {
    _patientsModel = await PatientServices.getAll();
    notifyListeners();
  }

  // Login Nurse
  Future<void> loginPatient(String email, String pass) async {
    _patientAddModel = await PatientServices.login(email, pass);
    notifyListeners();
  }

  // Update Nurse
  Future<void> updatePatient({
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

  Future<void> deletePatient({required int id}) async {
    await PatientServices.delete(id); // استدعاء دالة الحذف من الخدمة
    notifyListeners();
  }

  Future<void> deletePatientNurse(
      { required int nurseId, required int patientId}) async {
    await PatientServices.deletePatient(nurseId, patientId);
    notifyListeners();
  }
}