import 'package:enhanced_custom_forms/enhanced_custom_forms.dart'
    show Consumer, FormElement;
import 'package:example/extensions/widget_on_form_element.dart';
import 'package:example/providers/form_editor.dart';
import 'package:example/widgets/central_loading.dart';
import 'package:flutter/material.dart';

class FormEditorPage extends StatelessWidget {
  const FormEditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Form Editor"),
      ),
      body: Consumer<PxFormEditor>(
        builder: (context, editor, _) {
          while (editor.form == null) {
            return const CentralLoading();
          }
          return Row(
            children: [
              Expanded(
                flex: 4,
                child: Card.outlined(
                  elevation: 6,
                  child: LayoutBuilder(
                    builder: (context, constrains) {
                      final width = constrains.maxWidth;
                      final height = constrains.maxHeight;

                      return Stack(
                        fit: StackFit.expand,
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: width,
                              height: height,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(),
                                ],
                              ),
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      ...List.generate(
                                          editor.form!.formLayout.columns,
                                          (i) => i).map((e) {
                                        return Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(),
                                                color: Colors.white70,
                                              ),
                                              child: DragTarget<Widget>(
                                                builder: (context,
                                                    candidateData,
                                                    rejectedData) {
                                                  return const SizedBox(
                                                      height: 70);
                                                },
                                                onAcceptWithDetails: (details) {
                                                  details.data;
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Card.outlined(
                  elevation: 6,
                  child: ListView(
                    padding: const EdgeInsets.all(8.0),
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        editor.form!.titleEn.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...FormElement.values.map((e) {
                        return e.buildElement();
                      }),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
