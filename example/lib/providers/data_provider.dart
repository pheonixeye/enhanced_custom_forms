import 'package:enhanced_custom_forms/enhanced_custom_forms.dart';
import 'package:example/api/api.dart';
import 'package:flutter/material.dart';

class PxData extends ChangeNotifier {
  final API api;

  PxData({required this.api}) {
    _init();
  }

  Future<void> _init() async {
    await api.init();
    await _fetchAllForms();
  }

  List<ProClinicForm>? _forms;
  List<ProClinicForm>? get forms => _forms;

  Future<void> _fetchAllForms() async {
    final result = await api.fetchAllForms();
    _forms = result;
    notifyListeners();
  }

  Future<void> createForm(ProClinicForm form) async {
    await api.createForm(form);
    await _fetchAllForms();
  }
}
