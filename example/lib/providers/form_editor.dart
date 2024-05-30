import 'package:enhanced_custom_forms/enhanced_custom_forms.dart';
import 'package:example/api/api.dart';
import 'package:flutter/material.dart';

class PxFormEditor extends ChangeNotifier {
  final API api;
  final BuildContext context;

  PxFormEditor({required this.context, required this.api});

  ProClinicForm? _form;
  ProClinicForm? get form => _form;

  void selectForm(ProClinicForm? value) {
    _form = value;
    notifyListeners();
  }

  Rect? _rect;
  Rect? get rect => _rect;
}
