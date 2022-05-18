import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sacre_memento_app/view/welcoming_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  static const kuning = Color.fromARGB(255,  242, 160, 15);
  static const kuning2 = Color.fromARGB(255, 242, 139, 14);
  static const kuning3 = Color.fromARGB(255,  191, 55, 6);
  static const biru = CupertinoColors.systemBlue;

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WelcomingPage(),
      debugShowCheckedModeBanner: true,
    );
  }
}
