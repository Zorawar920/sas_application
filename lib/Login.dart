import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  final String inputData;
  //Constructor
  Login(String s, {Key? key, required this.inputData});

  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    print("I Am here");
    return (Text("LOGIN"));
  }
}
