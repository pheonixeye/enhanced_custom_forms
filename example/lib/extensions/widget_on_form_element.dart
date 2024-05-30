import 'package:enhanced_custom_forms/enhanced_custom_forms.dart';
import 'package:flutter/material.dart';

extension WidgetOnFormElement on FormElement {
  Widget buildElement({void Function(DraggableDetails)? onDragEnd}) {
    final Widget element = switch (this) {
      FormElement.textfield => Card.outlined(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              enabled: false,
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
      FormElement.radio => Card.outlined(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RadioListTile(
              title: Text(toString()),
              onChanged: null,
              groupValue: null,
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
    };
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Draggable<Widget>(
        data: element,
        feedback: SizedBox(
          height: 70,
          width: 300,
          child: element,
        ),
        onDragEnd: onDragEnd,
        child: element,
      ),
    );
  }
}
