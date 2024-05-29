import 'package:enhanced_custom_forms/enhanced_custom_forms.dart';
import 'package:example/api/api.dart';
import 'package:example/providers/data_provider.dart';
import 'package:flutter/material.dart';

class PxFormEditor extends ChangeNotifier {
  final API api;
  final BuildContext context;

  PxFormEditor({required this.context, required this.api});

  ProClinicForm? _form;
  ProClinicForm? get form => _form;

  void selectForm(ProClinicForm? value) {
    _form = value;
    _initRect(context);
    notifyListeners();
  }

  Rect? _rect;
  Rect? get rect => _rect;

  void _initRect(BuildContext context) {
    _rect = Rect.fromCenter(
      center: MediaQuery.of(context).size.center(Offset.zero),
      width: _form!.width,
      height: _form!.length,
    );
    notifyListeners();
  }

  void setRect(Rect rect) {
    _rect = rect;
    notifyListeners();
  }

  Future<void> updateFormDimensions() async {
    if (_form != null && _rect != null) {
      await context.read<PxData>().updateForm(_form!.copyWith(
            width: _rect!.width,
            length: _rect!.height,
          ));
      if (context.mounted) {
        selectForm(
          context.read<PxData>().forms!.firstWhere((x) => x.id == _form!.id),
        );
      }
    }
  }
}
