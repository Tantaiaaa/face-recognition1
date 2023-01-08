import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/home_sreen.dart';
import 'package:flutter_application_1/screen/loginsreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'สแกนใบหน้าเช็คชื่อเข้าเรียน',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
