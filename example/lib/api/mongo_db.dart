import 'package:enhanced_custom_forms/enhanced_custom_forms.dart';
import 'package:example/api/api.dart';
import 'package:flutter/foundation.dart';

class MongoDb extends API {
  MongoDb(super.source);

  static final Db mongo = Db('mongodb://127.0.0.1:27017/proclinic');
  final DbCollection forms = mongo.collection('forms');

  @override
  Future<void> createForm(ProClinicForm proClinicForm) async {
    await forms.insertOne(proClinicForm.toJson());
  }

  @override
  Future<void> deleteForm(ProClinicForm proClinicForm) {
    // TODO: implement deleteForm
    throw UnimplementedError();
  }

  @override
  Future<List<ProClinicForm>> fetchAllForms() async {
    final result = await forms.find().toList();
    final _forms = result.map((e) => ProClinicForm.fromJson(e)).toList();
    return _forms;
  }

  @override
  Future<ProClinicForm> updateForm(ProClinicForm proClinicForm) {
    // TODO: implement updateForm
    throw UnimplementedError();
  }

  @override
  Future<void> init() async {
    await mongo.open().then((_) {
      if (kDebugMode) {
        print("MongoDb().init()");
      }
    });
  }
}
