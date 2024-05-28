import 'package:enhanced_custom_forms/enhanced_custom_forms.dart';
import 'package:example/api/api.dart';
import 'package:example/constants/data_source.dart';
import 'package:example/providers/data_provider.dart';

List<SingleChildWidget> providers(DataSource source) => [
      ChangeNotifierProvider(
        create: ((context) => PxData(
              api: API.create(source),
            )),
      ),
    ];
