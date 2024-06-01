import 'package:enhanced_custom_forms/enhanced_custom_forms.dart'
    show FormDataElement, FormElementDataOption, FormElement;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class EditFormElementDialog extends StatefulWidget {
  const EditFormElementDialog({super.key, required this.data});
  final FormDataElement data;

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

  late bool isRequired;
  late List<FormElementDataOption> _dataOptions;

  @override
  void initState() {
    isRequired = widget.data.required;
    _dataOptions = widget.data.options;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text("Edit Element (${widget.data.formElement.toString()})"),
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
                ),
              ),
              const Divider(),
              CheckboxListTile.adaptive(
                title: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Required"),
                ),
                value: isRequired,
                onChanged: (value) {
                  setState(() {
                    if (value != null) {
                      isRequired = value;
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

                    switch (widget.data.formElement) {
                      case FormElement.dropdown:
                        setState(() {
                          _dataOptions.add(FormElementDataOption.createEmpty());
                        });
                        break;
                      case FormElement.radio:
                      case FormElement.image:
                        if (_dataOptions.isEmpty) {
                          setState(() {
                            _dataOptions
                                .add(FormElementDataOption.createEmpty());
                          });
                        } else {
                          await EasyLoading.showInfo(
                              "(${widget.data.formElement.toString().toUpperCase()}) Can Have Only One Option.");
                        }
                        break;
                      case FormElement.textfield:
                      case FormElement.checkbox:
                      case FormElement.text:
                        await EasyLoading.showInfo(
                            "(${widget.data.formElement.toString().toUpperCase()}) Has No Data Options.");
                        break;
                    }
                  },
                  child: const Icon(Icons.add),
                ),
              ),
              const Divider(),
              ..._dataOptions.map((e) {
                return switch (widget.data.formElement) {
                  FormElement.textfield ||
                  FormElement.checkbox ||
                  FormElement.text =>
                    const SizedBox(),
                  FormElement.radio || FormElement.dropdown => Column(
                      children: [
                        ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                                "** Option ${_dataOptions.indexOf(e) + 1}"),
                          ),
                          trailing: IconButton.outlined(
                            onPressed: () {
                              setState(() {
                                _dataOptions.remove(e);
                              });
                            },
                            icon: const Icon(Icons.delete_forever),
                          ),
                        ),
                        ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("${widget.data.formElement} Title"),
                          ),
                          subtitle: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            validator: _validator,
                          ),
                        ),
                        ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                Text("${widget.data.formElement} Description"),
                          ),
                          subtitle: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            // validator: _validator,
                          ),
                        ),
                        ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("${widget.data.formElement} Value"),
                          ),
                          subtitle: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            validator: _validator,
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
                      subtitle: const SizedBox(
                        width: 200,
                        height: 200,
                        //TODO: show picked image
                      ),
                      trailing: FloatingActionButton.small(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        heroTag: 'add-img-btn',
                        onPressed: () {
                          //TODO: pick and store image
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
              //TODO: save changes to formDataElement
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
