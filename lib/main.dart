import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:profilescreen/screens/tabs.dart';

import 'data/models/data_model.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(DataModelAdapter().typeId)) {
    Hive.registerAdapter(DataModelAdapter());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(

      debugShowCheckedModeBanner: false,
        home: TabsScreen());
  }
}
