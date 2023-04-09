import 'dart:io';

import 'package:creative_task/providers/provider.dart';
import 'package:creative_task/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() async {
  Workmanager().registerPeriodicTask(
    "periodic-task-identifier",
    "simplePeriodicTask",
    // When no frequency is provided the default 15 minutes is set.
    // Minimum frequency is 15 min. Android will automatically change your frequency to 15 min if you have configured a lower frequency.
    frequency: const Duration(hours: 6),
  );
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setBool('saved', false);
  var dir = await getTemporaryDirectory();
  String fileName = "userdata.json";
  File file = File("${dir.path}/$fileName");
  await file.delete();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => CustomProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}
