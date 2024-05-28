import 'package:enhanced_custom_forms/enhanced_custom_forms.dart' show Consumer;
import 'package:example/pages/homepage/widgets/create_form_dialog.dart';
import 'package:example/providers/data_provider.dart';
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
              return const Center(
                child: Card.outlined(
                  elevation: 6,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Loading..."),
                        SizedBox(height: 25),
                        CircularProgressIndicator(),
                      ],
                    ),
                  ),
                ),
              );
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
              itemBuilder: (context, index) {
                final _form = d.forms![index];
                return ListTile(
                  title: Text(_form.titleEn),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
