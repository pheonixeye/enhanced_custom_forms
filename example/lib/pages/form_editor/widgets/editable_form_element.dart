import 'dart:convert';

import 'package:enhanced_custom_forms/enhanced_custom_forms.dart'
    show FormDataElement, FormElement, ReadContext;
import 'package:example/pages/form_editor/widgets/edit_element_dialog.dart';
import 'package:example/providers/form_editor.dart';
import 'package:flutter/material.dart';

class EditableFormElement extends StatefulWidget {
  const EditableFormElement({super.key, required this.data});
  final FormDataElement data;

  @override
  State<EditableFormElement> createState() => _EditableFormElementState();
}

class _EditableFormElementState extends State<EditableFormElement> {
  bool _checkboxValue = false;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      elevation: 6,
      child: Tooltip(
        message: widget.data.description ?? '',
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: switch (widget.data.formElement) {
                  FormElement.textfield => TextFormField(
                      expands: true,
                      enabled: widget.data.title !=
                          widget.data.formElement.toString(),
                      maxLines: null,
                      minLines: null,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText:
                            "${widget.data.title}${widget.data.required ? "(Required)" : ""}",
                      ),
                    ),
                  FormElement.checkbox => CheckboxListTile(
                      title: Text(widget.data.title),
                      onChanged: widget.data.title ==
                              widget.data.formElement.toString()
                          ? null
                          : (value) {
                              if (value != null) {
                                setState(() {
                                  _checkboxValue = value;
                                });
                              }
                            },
                      value: _checkboxValue,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                  FormElement.dropdown => DropdownButtonFormField<String>(
                      isExpanded: true,
                      items: widget.data.options.map((e) {
                        return DropdownMenuItem<String>(
                            alignment: Alignment.center,
                            value: e.value,
                            child: Text(
                              e.title,
                              textAlign: TextAlign.center,
                            ));
                      }).toList(),
                      alignment: Alignment.center,
                      onChanged: widget.data.title ==
                              widget.data.formElement.toString()
                          ? null
                          : (value) {},
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: widget.data.title,
                      ),
                    ),
                  FormElement.image => (widget.data.options.isEmpty ||
                          widget.data.options.first.value.isEmpty)
                      ? const CircleAvatar(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 42,
                          ),
                        )
                      : Image.memory(
                          base64Decode(widget.data.options.first.value)),
                  FormElement.text => Center(
                      child: Text(
                        widget.data.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                },
              ),
              const SizedBox(width: 10),
              PopupMenuButton<String>(
                child: const Icon(Icons.menu),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (context) => EditFormElementDialog(
                            formElement: widget.data,
                          ),
                        );
                      },
                      child: const Text("Edit"),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        context
                            .read<PxFormEditor>()
                            .removeDataElement(widget.data);
                      },
                      child: const Text("Delete"),
                    ),
                  ];
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
