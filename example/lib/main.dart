import 'package:enhanced_custom_forms/enhanced_custom_forms.dart';
import 'package:example/constants/data_source.dart';
import 'package:example/pages/homepage/homepage.dart';
import 'package:example/providers/_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppProvider());
}

class AppProvider extends StatelessWidget {
  const AppProvider({super.key});
  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _providers = providers(DataSource.MongoDb);
    return MultiProvider(
      providers: _providers,
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enhanced Custom Forms',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      builder: EasyLoading.init(),
      home: const MyHomePage(title: 'Enhanced Custom Forms Maker'),
    );
  }
}
