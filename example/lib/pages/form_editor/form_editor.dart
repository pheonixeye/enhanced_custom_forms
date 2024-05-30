import 'package:enhanced_custom_forms/enhanced_custom_forms.dart'
    show Consumer, FormElement, FormDataElement;
import 'package:example/extensions/widget_on_form_element.dart';
import 'package:example/providers/form_editor.dart';
import 'package:example/widgets/central_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';

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
                              child: (editor.elements[editor.page] == null)
                                  ? const SizedBox()
                                  : ListView.builder(
                                      itemCount: 20,
                                      itemBuilder: (context, index) {
                                        return Row(
                                          children: [
                                            ...List.generate(
                                                editor.form!.formLayout.columns,
                                                (i) => i).map((e) {
                                              return Expanded(
                                                flex: 1,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(1.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        width: 0.5,
                                                      ),
                                                      color: Colors.white70,
                                                    ),
                                                    child: const SizedBox(
                                                        height: 70),
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
                          if (editor.elements[editor.page] == null)
                            const SizedBox()
                          else
                            ...editor.elements[editor.page]!.map((x) {
                              return TransformableBox(
                                rect: Offset(x.startX, x.startY) &
                                    Size(x.spanX, x.spanY),
                                contentBuilder: (context, rect, flip) {
                                  return x.formElement.element;
                                },
                                onResizeUpdate: (result, event) {
                                  editor.updateDataElement(x.copyWith(
                                    spanX: x.spanX + result.rawSize.width,
                                    spanY: x.spanY + result.rawSize.height,
                                  ));
                                },
                                onDragUpdate: (result, event) {
                                  editor.updateDataElement(x.copyWith(
                                    startX: x.startX + result.delta.dx,
                                    startY: x.startY + result.delta.dy,
                                  ));
                                },
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
                        "${editor.form!.titleEn.toUpperCase()}\n(${editor.elements.keys.last}) Page(s)",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FloatingActionButton.small(
                            heroTag: 'prev',
                            onPressed: () {
                              editor.prevPage();
                            },
                            child: const Icon(Icons.arrow_back),
                          ),
                          Text(editor.page.toString()),
                          FloatingActionButton.small(
                            heroTag: 'next',
                            onPressed: () {
                              editor.nextPage();
                            },
                            child: const Icon(Icons.arrow_forward),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      ...FormElement.values.map((e) {
                        return e.buildElement(
                          onDragEnd: (details) {
                            editor.addDataElement(FormDataElement.create(
                              title: e.name,
                              formElement: e,
                              startX: details.offset.dx,
                              startY: details.offset.dy,
                            ));
                          },
                        );
                      }),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          editor.addNewPage();
                        },
                        icon: const Icon(Icons.add),
                        label: const Text("Add New Page"),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          editor.removePage();
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text("Remove Page"),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          editor.clearForm();
                        },
                        icon: const Icon(Icons.clear_all),
                        label: const Text("Clear Form"),
                      ),
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
