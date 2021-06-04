import 'package:flutter/material.dart';
import './Uniformity/Widgets.dart';

class Signup extends StatefulWidget {
  final String inputData;
  //Constructor
  Signup({Key? key, required this.inputData});

  @override
  State<StatefulWidget> createState() => SignupState();
}

class SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return (Text("SIGNUP"));
  }
}
