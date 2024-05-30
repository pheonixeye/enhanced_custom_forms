import 'package:enhanced_custom_forms/enhanced_custom_forms.dart';
import 'package:example/api/api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PxFormEditor extends ChangeNotifier {
  final API api;
  final BuildContext context;

  PxFormEditor({required this.context, required this.api}) {
    _elements.putIfAbsent(page, () => []);
  }

  ProClinicForm? _form;
  ProClinicForm? get form => _form;

  int _page = 1;
  int get page => _page;

  void prevPage() {
    final val = _page - 1;
    if (_elements.keys.contains(val)) {
      _page--;
      notifyListeners();
    }
  }

  void nextPage() {
    final val = _page + 1;
    if (_elements.keys.contains(val)) {
      _page++;
      notifyListeners();
    }
  }

  final Map<int, List<FormDataElement>> _elements = {};
  Map<int, List<FormDataElement>> get elements => _elements;

  void selectForm(ProClinicForm? value) {
    _form = value;
    notifyListeners();
  }

  void addDataElement(FormDataElement element) {
    _elements[page]?.add(element);
    notifyListeners();
  }

  void addNewPage() {
    final length = _elements.length;
    _elements.putIfAbsent(length + 1, () => []);
    notifyListeners();
  }

  void removePage() {
    _elements.remove(_page);
    notifyListeners();
    _moveAfterRemovePage();
  }

  void _moveAfterRemovePage() {
    nextPage();
    prevPage();
  }

  void clearForm() {
    _elements.clear();
    notifyListeners();
  }

  void updateDataElement(FormDataElement element) {
    // ignore: unused_local_variable
    FormDataElement? originalElement =
        _elements[page]?.firstWhere((x) => x.id == element.id);
    originalElement = element;
    notifyListeners();
    if (kDebugMode) {
      print("PxFormEditor().updateDataElement($page - $element)");
    }
  }
}
