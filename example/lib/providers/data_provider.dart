import 'package:enhanced_custom_forms/enhanced_custom_forms.dart';
import 'package:example/api/api.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';

class PxData extends ChangeNotifier {
  final API api;

  PxData({required this.api}) {
    _init();
  }

  Future<void> _init() async {
    await api.init();
    if (kDebugMode) {
      print("PxData()._init()");
    }
    await _fetchAllForms();
  }

  List<ProClinicForm>? _forms;
  List<ProClinicForm>? get forms => _forms;

  Future<void> _fetchAllForms() async {
    final result = await api.fetchAllForms();
    _forms = result;
    notifyListeners();
    if (kDebugMode) {
      print("PxData()._fetchAllForms()");
    }
  }

  Future<void> createForm(ProClinicForm form) async {
    await api.createForm(form);
    if (kDebugMode) {
      print("PxData().createForm()");
    }
    await _fetchAllForms();
  }

  Future<void> updateForm(ProClinicForm form) async {
    await api.updateForm(form);
    if (kDebugMode) {
      print("PxData().updateForm()");
    }
    await _fetchAllForms();
  }

  Future<void> deleteForm(ProClinicForm form) async {
    await api.deleteForm(form);
    if (kDebugMode) {
      print("PxData().deleteForm()");
    }
    await _fetchAllForms();
  }
}
