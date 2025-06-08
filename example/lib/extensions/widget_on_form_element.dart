import 'package:flutter/material.dart';
import 'package:proclinic_models/proclinic_models.dart';

extension WidgetOnFormElement on FormElement {
  Widget get selectionElement => switch (this) {
        FormElement.textfield => Card.outlined(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                expands: true,
                enabled: false,
                maxLines: null,
                minLines: null,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: toString(),
                ),
              ),
            ),
          ),
        FormElement.checkbox => Card.outlined(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CheckboxListTile(
                title: Text(toString()),
                onChanged: null,
                value: true,
              ),
            ),
          ),
        FormElement.dropdown => Card.outlined(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField(
                items: const [],
                onChanged: null,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: toString(),
                ),
              ),
            ),
          ),
        FormElement.image => const Card.outlined(
            elevation: 6,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                child: Icon(
                  Icons.image,
                  size: 42,
                ),
              ),
            ),
          ),
        FormElement.text => const Card.outlined(
            elevation: 6,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "Text",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ),
      };
  Widget buildElement({void Function(DraggableDetails)? onDragEnd}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Draggable<Widget>(
        data: selectionElement,
        feedback: SizedBox(
          height: 70,
          width: 300,
          child: selectionElement,
        ),
        onDragEnd: onDragEnd,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 70),
          child: selectionElement,
        ),
      ),
    );
  }
}
