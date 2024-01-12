import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../models/data_model.dart';


class DatabaseSource {
  late Box<DataModel> _database;

  ValueNotifier<List<DataModel>> dataListNotifier = ValueNotifier([]);

  Future<void> initHive() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);
    await openBox(); // Add this line to open the box
  }


  Future<void> openBox() async {
    _database = await Hive.openBox<DataModel>('app_db');
  }

  Future<void> saveData(DataModel model, dynamic key) async {
    await openBox(); // Ensure the box is open before saving data
    if (key == null) {
      _addData(model);
    } else {
      _updateData(model, key);
    }
    await getAllData();
  }

  Future<void> getAllData() async {
    dataListNotifier.value = _database.values.toList();
  }

  Future<void> deleteData(int id) async {
    _database.delete(id);
    await getAllData();
  }

  Future<void> _addData(DataModel model) async {
    await _database.add(model);
    await getAllData();
  }

  Future<void> _updateData(DataModel model, dynamic key) async {
    _database.put(key, model);
  }
}
