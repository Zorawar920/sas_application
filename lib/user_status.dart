import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sas_application/screens/log_in.dart';
import 'package:sas_application/screens/home_page.dart';
import 'package:sas_application/firebase_services/auth.dart';

class UserStatus extends StatelessWidget {
  final AuthBase auth;

  const UserStatus({Key? key, required this.auth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return LogIn(
              "Login Page",
              inputData: "Transmit Data",
              auth: auth,
            );
          }
          return HomePage(
            auth: auth,
          );
        }
        return Scaffold(
          body: Center(
              child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red))),
        );
      },
    );
  }
}
