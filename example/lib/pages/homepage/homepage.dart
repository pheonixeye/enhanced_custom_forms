import 'package:enhanced_custom_forms/enhanced_custom_forms.dart' show Consumer;
import 'package:example/pages/homepage/widgets/create_form_dialog.dart';
import 'package:example/pages/homepage/widgets/form_tile.dart';
import 'package:example/providers/data_provider.dart';
import 'package:example/widgets/central_loading.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'create-new-form',
        onPressed: () async {
          //todo: create new form dialog
          await showDialog(
              context: context,
              builder: (context) {
                return const CreateNewFormDialog();
              });
        },
        tooltip: "Create New Form",
        child: const Icon(Icons.add),
      ),
      body: Card.outlined(
        elevation: 6,
        child: Consumer<PxData>(
          builder: (context, d, _) {
            while (d.forms == null) {
              return const CentralLoading();
            }
            while (d.forms!.isEmpty) {
              return const Center(
                child: Card.outlined(
                  elevation: 6,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("No Forms Found."),
                      ],
                    ),
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: d.forms?.length,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (context, index) {
                final form = d.forms![index];
                return FormTile(
                  form: form,
                  index: index,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
