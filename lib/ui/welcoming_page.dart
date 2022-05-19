import 'package:flutter/material.dart';
import 'dart:async';

import 'package:sacre_memento_app/ui/main_page.dart';

import '../api/login_api.dart';

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
    return Timer(duration, (() async {
      var isAuthenticated = await LoginApi.authenticate();

      while (!isAuthenticated) {
        isAuthenticated = await LoginApi.authenticate();
      }
      if (isAuthenticated) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) => const MainPage())));
      }
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
