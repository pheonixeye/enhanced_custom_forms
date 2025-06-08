import 'package:example/api/firebase_db.dart';
import 'package:example/api/hive_db.dart';
import 'package:example/api/json_db.dart';
import 'package:example/api/mongo_db.dart';
import 'package:example/constants/data_source.dart';
import 'package:proclinic_models/proclinic_models.dart';

abstract class API {
  final DataSource source;

  const API(this.source);

  Future<void> init();

  Future<List<ProClinicForm>> fetchAllForms();

  Future<void> createForm(ProClinicForm proClinicForm);

  Future<void> updateForm(ProClinicForm proClinicForm);

  Future<void> deleteForm(ProClinicForm proClinicForm);

  factory API.create(DataSource source) {
    return switch (source) {
      DataSource.MongoDb => MongoDb(source),
      DataSource.Hive => HiveDb(source),
      DataSource.Json => JsonDb(source),
      DataSource.Firebase => FirebaseDb(source),
    };
  }
}
