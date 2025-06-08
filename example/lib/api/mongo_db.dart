import 'package:example/api/api.dart';
import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:proclinic_models/proclinic_models.dart';

class MongoDb extends API {
  MongoDb(super.source);

  //TODO: change at deployment
  static final Db mongo = Db('mongodb://192.168.1.88:27017/proclinic');
  final DbCollection forms = mongo.collection('forms');

  @override
  Future<void> createForm(ProClinicForm proClinicForm) async {
    await forms.insertOne(proClinicForm.toJson());
  }

  @override
  Future<void> deleteForm(ProClinicForm proClinicForm) async {
    await forms.deleteOne(where.eq("_id", proClinicForm.id));
  }

  @override
  Future<List<ProClinicForm>> fetchAllForms() async {
    final result = await forms.find().toList();
    // ignore: no_leading_underscores_for_local_identifiers
    final _forms = result.map((e) => ProClinicForm.fromJson(e)).toList();
    return _forms;
  }

  @override
  Future<void> updateForm(ProClinicForm proClinicForm) async {
    await forms.updateOne(
      where.eq("_id", proClinicForm.id),
      {
        r'$set': {
          ...proClinicForm.toJson(),
        }
      },
    );
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
