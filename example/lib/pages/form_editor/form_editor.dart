import 'package:enhanced_custom_forms/enhanced_custom_forms.dart'
    show Consumer, FormElement, FormDataElement, ObjectId;
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
                                cacheExtent: 5000,
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
                                              child: const SizedBox(height: 70),
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
                          ...editor.elements.map((x) {
                            return Positioned(
                              width: x.spanX,
                              height: x.spanY,
                              top: x.startX,
                              left: x.startY,
                              child: x.formElement.buildElement(
                                onDragEnd: (details) {
                                  editor.updateDataElement(x.copyWith(
                                    startX: details.offset.dx,
                                    startY: details.offset.dy,
                                  ));
                                },
                              ),
                            );
                          }),
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
                        return e.buildElement(
                          onDragEnd: (details) {
                            final formElement = FormDataElement(
                              id: ObjectId(),
                              title: e.toString(),
                              formElement: e,
                              required: false,
                              startX: details.offset.dx,
                              startY: details.offset.dy,
                              spanX: 250,
                              spanY: 70,
                              options: const [],
                            );
                            editor.addDataElement(formElement);
                          },
                        );
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
