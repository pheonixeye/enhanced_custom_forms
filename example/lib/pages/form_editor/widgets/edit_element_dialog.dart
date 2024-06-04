// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:enhanced_custom_forms/enhanced_custom_forms.dart'
    show
        Equatable,
        FormDataElement,
        FormElement,
        FormElementDataOption,
        ReadContext;
import 'package:example/providers/form_editor.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

// ignore: unused_element
class _FormDialogState extends Equatable {
  final FormDataElement element;
  final List<FormElementDataOption> options;

  _FormDialogState({
    required this.element,
  }) : options = element.options;

  @override
  List<Object?> get props => [element, options];

  void addOption(FormElementDataOption option) {
    options.add(option);
  }

  void removeOption(FormElementDataOption option) {
    options.remove(option);
  }

  void editOption(FormElementDataOption option, int index) {
    options[index] = option;
  }

  _FormDialogState copyWith({
    String? title,
    String? description,
    bool? required,
  }) {
    return _FormDialogState(
      element: element.copyWith(
        title: title ?? element.title,
        description: description ?? element.description,
        required: required ?? element.required,
        options: options,
      ),
    );
  }
}

class EditFormElementDialog extends StatefulWidget {
  const EditFormElementDialog({super.key, required this.formElement});
  final FormDataElement formElement;

  @override
  State<EditFormElementDialog> createState() => _EditFormElementDialogState();
}

class _EditFormElementDialogState extends State<EditFormElementDialog> {
  final formKey = GlobalKey<FormState>();

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return "Empty Inputs Are Not Allowed";
    }
    return null;
  }

  late _FormDialogState _state;

  @override
  void initState() {
    _state = _FormDialogState(element: widget.formElement);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text("Edit Element (${widget.formElement.formElement.toString()})"),
          const Spacer(),
          FloatingActionButton.small(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            heroTag: 'close-edit-dialog',
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.close),
          ),
        ],
      ),
      scrollable: true,
      content: Container(
        width: 600,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(),
          ],
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              ListTile(
                title: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Element Title"),
                ),
                subtitle: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: _validator,
                  initialValue: _state.element.title,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        _state = _state.copyWith(
                          title: value,
                        );
                      });
                    }
                  },
                ),
              ),
              const Divider(),
              ListTile(
                title: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Element Description"),
                ),
                subtitle: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  // validator: _validator,
                  initialValue: _state.element.description,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        _state = _state.copyWith(
                          description: value,
                        );
                      });
                    }
                  },
                ),
              ),
              const Divider(),
              CheckboxListTile.adaptive(
                title: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Required"),
                ),
                value: _state.element.required,
                onChanged: (value) {
                  setState(() {
                    if (value != null) {
                      _state = _state.copyWith(required: value);
                    }
                  });
                },
              ),
              const Divider(),
              ListTile(
                title: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Form Data Options"),
                ),
                trailing: FloatingActionButton.small(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  heroTag: 'add-form-data-option',
                  onPressed: () async {
                    //todo: ADD FORM DATA OPTION

                    switch (widget.formElement.formElement) {
                      case FormElement.dropdown:
                        setState(() {
                          _state.addOption(FormElementDataOption.createEmpty());
                          _state.copyWith();
                        });
                        break;
                      case FormElement.image:
                        if (_state.options.isEmpty) {
                          setState(() {
                            _state
                                .addOption(FormElementDataOption.createEmpty());
                            _state.copyWith();
                          });
                        } else {
                          await EasyLoading.showInfo(
                              "(${widget.formElement.formElement.toString().toUpperCase()}) Can Have Only One Option.");
                        }
                        break;
                      case FormElement.textfield:
                      case FormElement.checkbox:
                      case FormElement.text:
                        await EasyLoading.showInfo(
                            "(${widget.formElement.formElement.toString().toUpperCase()}) Has No Data Options.");
                        break;
                    }
                  },
                  child: const Icon(Icons.add),
                ),
              ),
              const Divider(),
              ..._state.options.map((e) {
                final index = _state.options.indexOf(e);
                return switch (widget.formElement.formElement) {
                  FormElement.textfield ||
                  FormElement.checkbox ||
                  FormElement.text =>
                    const SizedBox(),
                  FormElement.dropdown => Column(
                      children: [
                        ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                                "** Option ${_state.options.indexOf(e) + 1}"),
                          ),
                          trailing: IconButton.outlined(
                            onPressed: () {
                              setState(() {
                                _state.removeOption(e);
                                _state.copyWith();
                              });
                            },
                            icon: const Icon(Icons.delete_forever),
                          ),
                        ),
                        ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                Text("${widget.formElement.formElement} Title"),
                          ),
                          subtitle: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            validator: _validator,
                            initialValue: e.title,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                final eNew = e.copyWith(
                                  title: value,
                                );
                                setState(() {
                                  _state.editOption(eNew, index);
                                  _state.copyWith();
                                });
                              }
                            },
                          ),
                        ),
                        ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "${widget.formElement.formElement} Description"),
                          ),
                          subtitle: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            initialValue: e.description,
                            // validator: _validator,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                final eNew = e.copyWith(
                                  description: value,
                                );
                                setState(() {
                                  _state.editOption(eNew, index);
                                  _state.copyWith();
                                });
                              }
                            },
                          ),
                        ),
                        ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                Text("${widget.formElement.formElement} Value"),
                          ),
                          subtitle: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            initialValue: e.value,
                            validator: _validator,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                final eNew = e.copyWith(
                                  value: value,
                                );
                                setState(() {
                                  _state.editOption(eNew, index);
                                  _state.copyWith();
                                });
                              }
                            },
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
                  FormElement.image => ListTile(
                      title: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Pick Image"),
                      ),
                      subtitle: Container(
                        //todo: show picked image
                        width: 100,
                        height: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [BoxShadow()],
                          border: Border.all(),
                        ),
                        child: e.value == ''
                            ? const Text("No Image Selected")
                            : Image.memory(base64Decode(e.value)),
                      ),
                      trailing: FloatingActionButton.small(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        heroTag: 'add-img-btn',
                        onPressed: () async {
                          final result = await FilePicker.platform.pickFiles(
                            dialogTitle: "Select Image Path",
                            allowMultiple: false,
                            allowedExtensions: ['jpg', 'png', 'jpeg'],
                            type: FileType.image,
                            withData: true,
                          );
                          if (result != null) {
                            //todo: pick and store image
                            final imageBytes = result.files.first.bytes;
                            if (imageBytes != null) {
                              final imageBase = base64Encode(imageBytes);
                              final eNew = e.copyWith(
                                title: 'image',
                                description: 'image form element',
                                value: imageBase,
                              );
                              setState(() {
                                _state.editOption(eNew, index);
                                _state.copyWith();
                              });
                            }
                          }
                        },
                        child: const Icon(Icons.image),
                      ),
                    ),
                };
              }),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton.icon(
          onPressed: () {
            if (formKey.currentState != null &&
                formKey.currentState!.validate()) {
              //todo: save changes to formDataElement
              final editor = context.read<PxFormEditor>();
              editor.updateDataElement(_state.element);
              Navigator.pop(context);
            }
          },
          icon: const Icon(Icons.save),
          label: const Text("Confirm"),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
          label: const Text("Cancel"),
        ),
      ],
    );
  }
}
