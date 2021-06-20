import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sas_application/firebase_services/auth.dart';
import 'package:sas_application/singleton_instance.dart';
import 'home_page.dart';
import 'log_in.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Auth _auth = singletonInstance<Auth>();

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      if (_auth.currentUser == null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => HomePage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(children: <Widget>[
          Image.asset(
            'assets/logos/sos.png',
            height: 240,
            fit: BoxFit.fill,
          ),
        ]),
      ),
    );
  }
}
