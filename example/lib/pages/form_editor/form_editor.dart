import 'package:enhanced_custom_forms/enhanced_custom_forms.dart' show Consumer;
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
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          TransformableBox(
                            rect: editor.rect,
                            onResizeUpdate: (result, event) async {
                              //TODO: handle correctly
                              editor.setRect(result.rect);
                              await Future.delayed(const Duration(seconds: 1));
                              await editor.updateFormDimensions();
                            },
                            contentBuilder: (context, rect, flip) {
                              return DecoratedBox(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Card.outlined(
                  elevation: 6,
                  child: ListView(
                    children: [
                      Text(editor.form!.titleEn),
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
