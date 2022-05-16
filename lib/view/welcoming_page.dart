import 'package:flutter/material.dart';
import 'dart:async';

import 'package:sacre_memento_app/view/main_page.dart';

class WelcomingPage extends StatefulWidget {
  const WelcomingPage({Key? key}) : super(key: key);

  @override
  State<WelcomingPage> createState() => _WelcomingPageState();
}

class _WelcomingPageState extends State<WelcomingPage> {
  @override
  void initState() {
    super.initState();
    splashScreenStart();
  }

  splashScreenStart() async {
    var duration = const Duration(seconds: 1);
    return Timer(duration, (() {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: ((context) => const MainPage())));
    }));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Image(
        image: AssetImage('assets/welcome_potrait.png'),
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }
}
