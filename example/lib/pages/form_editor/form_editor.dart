import 'package:example/extensions/widget_on_form_element.dart';
import 'package:example/pages/form_editor/widgets/editable_form_element.dart';
import 'package:example/providers/form_editor.dart';
import 'package:example/widgets/central_loading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:proclinic_models/proclinic_models.dart';
import 'package:provider/provider.dart';

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
                                allowContentFlipping: false,
                                allowFlippingWhileResizing: false,
                                contentBuilder: (context, rect, flip) {
                                  return EditableFormElement(data: x);
                                },
                                onResizeUpdate: (result, event) {
                                  final update = x.copyWith(
                                    spanX: result.rawSize.width,
                                    spanY: result.rawSize.height,
                                  );
                                  if (kDebugMode) {
                                    print(
                                        'resize: X: (${update.spanX}) - Y: (${update.spanY})');
                                  }
                                  editor.updateDataElement(update);
                                },
                                onDragUpdate: (result, event) {
                                  final update = x.copyWith(
                                    startX: result.position.dx,
                                    startY: result.position.dy,
                                  );
                                  if (kDebugMode) {
                                    print(
                                        'drag: X: (${update.startX}) - (${update.startY})');
                                  }
                                  editor.updateDataElement(update);
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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final menuW = constraints.maxWidth;
                    final menuH = constraints.maxHeight;
                    return Card.outlined(
                      elevation: 6,
                      child: ListView(
                        padding: const EdgeInsets.all(8.0),
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            "${editor.form!.titleEn.toUpperCase()}\n-----\n(${editor.elements.keys.last}) Page(s)",
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
                              CircleAvatar(
                                child: Text(editor.page.toString()),
                              ),
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
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Form Layout'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField<FormLayout>(
                              isExpanded: true,
                              alignment: Alignment.center,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              items: FormLayout.values.map((e) {
                                return DropdownMenuItem<FormLayout>(
                                  alignment: Alignment.center,
                                  value: e,
                                  child: Text(e.toString()),
                                );
                              }).toList(),
                              hint: const Text("Form Layout"),
                              value: editor.form?.formLayout,
                              onChanged: (value) async {
                                if (value != null && editor.form != null) {
                                  final layoutUpdatedForm =
                                      editor.form?.copyWith(
                                    formLayout: value,
                                  );
                                  if (layoutUpdatedForm != null) {
                                    await editor
                                        .updateFormLayout(layoutUpdatedForm);
                                  }
                                }
                              },
                            ),
                          ),
                          const Divider(),
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Form Elements"),
                          ),
                          ...FormElement.values.map((e) {
                            return e.buildElement(
                              onDragEnd: (details) {
                                final screenW =
                                    MediaQuery.sizeOf(context).width;
                                final screenH =
                                    MediaQuery.sizeOf(context).height;
                                final editorW = screenW - menuW;

                                final Rect rect =
                                    Rect.fromLTWH(0, 0, editorW - 100, screenH);
                                if (kDebugMode) {
                                  print("menuC : $menuW * $menuH");
                                  print('editorW : $editorW');
                                  print('screenW : $screenW');
                                  print(
                                      "details Offset : ${details.offset.dx} * ${details.offset.dy}");
                                  print(rect);
                                }

                                if (rect.contains(details.offset)) {
                                  editor.addDataElement(FormDataElement.create(
                                    title: e.name,
                                    formElement: e,
                                    startX: details.offset.dx,
                                    startY: details.offset.dy,
                                    page: editor.page,
                                  ));
                                } else {
                                  EasyLoading.showInfo('Element Not Added.');
                                }
                              },
                            );
                          }),
                          const SizedBox(height: 10),
                          const Divider(),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Form Actions"),
                          ),
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
                            label: const Text("Remove Current Page"),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: () {
                              editor.clearCurrentPage();
                            },
                            icon: const Icon(Icons.cleaning_services_rounded),
                            label: const Text("Clear Current Page"),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: () {
                              editor.clearForm();
                            },
                            icon: const Icon(Icons.clear_all),
                            label: const Text("Clear Form"),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: () async {
                              //todo: SAVE FORM
                              await EasyLoading.show(status: "Loading...");
                              await editor.saveForm();
                              await EasyLoading.showSuccess("Success...");
                            },
                            icon: const Icon(Icons.save),
                            label: const Text("Save Form"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
