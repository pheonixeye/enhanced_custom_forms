import 'package:example/api/api.dart';
import 'package:example/constants/data_source.dart';
import 'package:example/providers/data_provider.dart';
import 'package:example/providers/form_editor.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers(DataSource source) => [
      ChangeNotifierProvider(
        create: ((context) => PxData(
              api: API.create(source),
            )),
      ),
      ChangeNotifierProvider(
        create: ((context) => PxFormEditor(
              api: API.create(source),
              context: context,
            )),
      ),
    ];
