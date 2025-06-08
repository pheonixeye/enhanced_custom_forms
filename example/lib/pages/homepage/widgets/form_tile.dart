import 'package:example/pages/form_editor/form_editor.dart';
import 'package:example/providers/data_provider.dart';
import 'package:example/providers/form_editor.dart';
import 'package:flutter/material.dart';
import 'package:proclinic_models/proclinic_models.dart';
import 'package:provider/provider.dart';

class FormTile extends StatelessWidget {
  const FormTile({super.key, required this.form, required this.index});
  final ProClinicForm form;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(
            child: Text("${index + 1}"),
          ),
          onTap: () {
            context.read<PxFormEditor>().selectForm(form);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FormEditorPage(),
              ),
            );
          },
          title: Text.rich(
            TextSpan(
              text: "Title : ",
              children: [
                TextSpan(text: "\nEn: ${form.titleEn}"),
                TextSpan(text: "\nAr: ${form.titleAr}"),
                const TextSpan(text: "\n--------------------"),
              ],
            ),
          ),
          subtitle: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: "Description : ",
                    children: [
                      TextSpan(
                          text:
                              '\nEn: ${(form.descriptionEn == null || form.descriptionEn!.isEmpty) ? '-.-.-.-.' : '${form.descriptionEn}'}'),
                      TextSpan(
                          text:
                              '\nAr: ${(form.descriptionAr == null || form.descriptionAr!.isEmpty) ? '-.-.-.-.' : '${form.descriptionAr}'}'),
                      const TextSpan(text: "\n--------------------"),
                      // const TextSpan(text: "\nDimensions : "),
                      // TextSpan(text: "\n${form.length}L * ${form.width}W"),
                      // const TextSpan(text: "\n--------------------"),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Wrap(
                  children: [
                    Text.rich(
                      TextSpan(
                        text: "Layout : ",
                        children: [
                          TextSpan(
                            text: "\n* ${form.formLayout.toString()}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none,
                            ),
                          )
                        ],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                      height: 20,
                    ),
                    Text.rich(
                      TextSpan(
                        text: "Form Elements : (${form.elements.length})",
                        children: [
                          const TextSpan(text: " \n"),
                          ...form.elements.map((e) {
                            return TextSpan(
                              text: '* ${e.title}, ',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.none,
                              ),
                            );
                          }),
                        ],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          trailing: FloatingActionButton(
            heroTag: form.id,
            onPressed: () async {
              if (context.mounted) {
                await context.read<PxData>().deleteForm(form);
              }
            },
            child: const Icon(Icons.delete_forever),
          ),
        ),
      ),
    );
  }
}
