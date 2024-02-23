import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:study_hive/models/person.dart';
import 'package:study_hive/page/hive_page.dart';

void main() async {
  //初始化Hive
  await Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter());
  await Hive.openBox<Person>('personBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive Demo',
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
        appBarTheme: const AppBarTheme(elevation: 0),
      ),
      home: HivePage(),
    );
  }
}
