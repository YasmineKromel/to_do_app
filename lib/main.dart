import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_do_app/views/calender2.dart';
import 'package:to_do_app/views/home.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  // should initialize firebase before run the App
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( ToDoApp());
}

class ToDoApp extends StatelessWidget {
   ToDoApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green
      ),
      home: const HomeScreen(),
    );
  }
}
