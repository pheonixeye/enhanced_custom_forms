import 'package:example/providers/data_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proclinic_models/proclinic_models.dart';
import 'package:provider/provider.dart';

class CreateNewFormDialog extends StatefulWidget {
  const CreateNewFormDialog({super.key});

  @override
  State<CreateNewFormDialog> createState() => _CreateNewFormDialogState();
}

class _CreateNewFormDialogState extends State<CreateNewFormDialog> {
  final formKey = GlobalKey<FormState>();

  String? _validator(String? value) {
    if (value == null || value.isEmpty) {
      return "Empty Field Not Allowed.";
    }
    return null;
  }

  String? _dropdownValidator(FormLayout? value) {
    if (value == null) {
      return "Empty Field Not Allowed.";
    }
    return null;
  }

  static const InputDecoration _decoration = InputDecoration(
    border: OutlineInputBorder(),
  );

  late final TextEditingController _titleEnController;
  late final TextEditingController _titleArController;
  late final TextEditingController _descriptionEnController;
  late final TextEditingController _descriptionArController;
  late final TextEditingController _lengthController;
  late final TextEditingController _widthController;

  FormLayout _formLayout = FormLayout.oneColumn;

  @override
  void initState() {
    _titleEnController = TextEditingController();
    _titleArController = TextEditingController();
    _descriptionEnController = TextEditingController();
    _descriptionArController = TextEditingController();
    _lengthController = TextEditingController();
    _widthController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleEnController.dispose();
    _titleArController.dispose();
    _descriptionEnController.dispose();
    _descriptionArController.dispose();
    _lengthController.dispose();
    _widthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Text('Create New Form'),
          const Spacer(),
          IconButton.filled(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      scrollable: true,
      content: SizedBox(
        width: 600,
        child: Card.outlined(
          elevation: 6,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('English Title'),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _titleEnController,
                      validator: _validator,
                      decoration: _decoration,
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Arabic Title'),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _titleArController,
                      validator: _validator,
                      decoration: _decoration,
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('English Description'),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _descriptionEnController,
                      decoration: _decoration,
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Arabic Description'),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _descriptionArController,
                      decoration: _decoration,
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Form Length'),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _lengthController,
                      validator: _validator,
                      decoration: _decoration,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Form Width'),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _widthController,
                      validator: _validator,
                      decoration: _decoration,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Form Layout'),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<FormLayout>(
                      alignment: Alignment.center,
                      decoration: _decoration,
                      isExpanded: true,
                      value: _formLayout,
                      onChanged: (value) {
                        setState(() {
                          if (value != null) {
                            _formLayout = value;
                          }
                        });
                      },
                      validator: _dropdownValidator,
                      items: FormLayout.values.map((e) {
                        return DropdownMenuItem<FormLayout>(
                          value: e,
                          alignment: Alignment.center,
                          child: Text(
                            e.toString(),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
          label: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              final form = ProClinicForm.create(
                titleEn: _titleEnController.text,
                titleAr: _titleArController.text,
                descriptionEn: _descriptionEnController.text,
                descriptionAr: _descriptionArController.text,
                length: double.parse(_lengthController.text),
                width: double.parse(_widthController.text),
                formLayout: _formLayout,
              );
              if (kDebugMode) {
                print(form);
              }
              //todo: add form to database
              if (context.mounted) {
                await context
                    .read<PxData>()
                    .createForm(form)
                    //todo: pop dialog
                    .then((_) => Navigator.pop(context));
              }
            }
          },
          icon: const Icon(Icons.check),
          label: const Text('Confirm'),
        ),
      ],
    );
  }
}
