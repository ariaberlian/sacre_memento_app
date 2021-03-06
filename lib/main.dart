import 'package:flutter/material.dart';
import 'package:sacre_memento_app/ui/welcoming_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

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
