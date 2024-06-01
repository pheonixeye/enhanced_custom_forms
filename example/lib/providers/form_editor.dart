import 'package:enhanced_custom_forms/enhanced_custom_forms.dart';
import 'package:example/api/api.dart';
import 'package:example/providers/data_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PxFormEditor extends ChangeNotifier {
  final API api;
  final BuildContext context;

  PxFormEditor({required this.context, required this.api});

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
    if (kDebugMode) {
      print("PxFormEditor().prevPage($page)");
    }
  }

  void nextPage() {
    final val = _page + 1;
    if (_elements.keys.contains(val)) {
      _page++;
      notifyListeners();
    }
    if (kDebugMode) {
      print("PxFormEditor().nextPage($page)");
    }
  }

  final Map<int, List<FormDataElement>> _elements = {};
  Map<int, List<FormDataElement>> get elements => _elements;

  void selectForm(ProClinicForm value) {
    _elements.clear();
    _page = 1;
    _form = value;
    _form!.elements.map((e) {
      _elements.putIfAbsent(e.page, () => []);
      _elements[e.page]?.add(e);
    }).toList();
    if (_elements.isEmpty) {
      _elements.putIfAbsent(1, () => []);
    }
    notifyListeners();
    if (kDebugMode) {
      print('PxFormEditor().selectForm(${_form?.titleEn})');
    }
  }

  void addDataElement(FormDataElement element) {
    _elements[page]?.add(element);
    notifyListeners();
    if (kDebugMode) {
      print("PxFormEditor().addDataElement($element)");
    }
  }

  void addNewPage() {
    final length = _elements.length;
    _elements.putIfAbsent(length + 1, () => []);
    notifyListeners();
    if (kDebugMode) {
      print("PxFormEditor().addNewPage(${_elements.keys.last})");
    }
  }

  void removePage() {
    _elements.remove(_page);
    notifyListeners();
    if (kDebugMode) {
      print("PxFormEditor().removePage()");
    }
    _moveAfterRemovePage();
  }

  void _moveAfterRemovePage() {
    nextPage();
    prevPage();
    if (kDebugMode) {
      print("PxFormEditor()._moveAfterRemovePage()");
    }
  }

  void clearForm() {
    _elements.clear();
    _elements.putIfAbsent(1, () => []);
    notifyListeners();
    if (kDebugMode) {
      print("PxFormEditor().clearForm()");
    }
  }

  void clearCurrentPage() {
    _elements[page] = [];
    notifyListeners();
    if (kDebugMode) {
      print("PxFormEditor().clearCurrentPage($page)");
    }
  }

  void updateDataElement(FormDataElement element) {
    // ignore: unused_local_variable
    FormDataElement? originalElement =
        _elements[page]?.firstWhere((x) => x.id == element.id);
    if (originalElement != null) {
      final index = _elements[page]!.indexOf(originalElement);
      _elements[page]![index] = element;
      notifyListeners();
    }
  }

  Future<void> updateFormLayout(ProClinicForm form) async {
    final pxData = context.read<PxData>();
    await pxData.updateForm(form);
    selectForm(pxData.forms!.firstWhere((x) => x.id == form.id));
    if (kDebugMode) {
      print("PxFormEditor().updateFormLayout(${form.formLayout})");
    }
  }

  Future<void> saveForm() async {
    final pxData = context.read<PxData>();
    if (_form != null) {
      final List<FormDataElement> elementList = [];
      _elements.values.map((e) {
        elementList.addAll(e);
      }).toList();
      _form = _form?.copyWith(elements: elementList);
      await pxData.updateForm(form!);
      selectForm(pxData.forms!.firstWhere((x) => x.id == form!.id));
      if (kDebugMode) {
        print("PxFormEditor().saveForm($form)");
      }
    }
  }
}
