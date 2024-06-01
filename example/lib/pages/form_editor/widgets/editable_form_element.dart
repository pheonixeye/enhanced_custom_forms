import 'package:enhanced_custom_forms/enhanced_custom_forms.dart'
    show FormDataElement, FormElement;
import 'package:example/pages/form_editor/widgets/edit_element_dialog.dart';
import 'package:flutter/material.dart';

class EditableFormElement extends StatelessWidget {
  const EditableFormElement({super.key, required this.data});
  final FormDataElement data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTap: () async {
        await showDialog(
          context: context,
          builder: (context) => EditFormElementDialog(
            data: data,
          ),
        );
      },
      child: Card.outlined(
        elevation: 6,
        child: Tooltip(
          message: data.description ?? '',
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: switch (data.formElement) {
              FormElement.textfield => TextFormField(
                  expands: true,
                  enabled: data.title != data.formElement.toString(),
                  maxLines: null,
                  minLines: null,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: data.title,
                  ),
                ),
              FormElement.checkbox => CheckboxListTile(
                  title: Text(data.title),
                  onChanged: null,
                  value: true,
                ),
              FormElement.radio => RadioListTile(
                  title: Text(data.title),
                  onChanged: null,
                  groupValue: null,
                  value: true,
                ),
              FormElement.dropdown => DropdownButtonFormField(
                  items: const [],
                  onChanged: null,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: data.title,
                  ),
                ),
              FormElement.image => const CircleAvatar(
                  child: Icon(
                    Icons.image,
                    size: 42,
                  ),
                ),
              FormElement.text => Center(
                  child: Text(
                    data.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
            },
          ),
        ),
      ),
    );
  }
}
