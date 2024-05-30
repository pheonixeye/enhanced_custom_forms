import 'package:enhanced_custom_forms/enhanced_custom_forms.dart';
import 'package:example/api/api.dart';
import 'package:flutter/material.dart';

class PxFormEditor extends ChangeNotifier {
  final API api;
  final BuildContext context;

  PxFormEditor({required this.context, required this.api});

  ProClinicForm? _form;
  ProClinicForm? get form => _form;

  final List<FormDataElement> _elements = [];
  List<FormDataElement> get elements => _elements;

  void selectForm(ProClinicForm? value) {
    _form = value;
    notifyListeners();
  }

  void addDataElement(FormDataElement element) {
    _elements.add(element);
    notifyListeners();
  }

  void updateDataElement(FormDataElement element) {
    FormDataElement _originalElement =
        _elements.firstWhere((x) => x.id == element.id);
    _elements.remove(_originalElement);
    _elements.add(element);
    notifyListeners();
  }
}
