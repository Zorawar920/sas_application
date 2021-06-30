import 'dart:async';
import 'package:flutter/material.dart';

class VarGradient extends StatefulWidget {
  @override
  _VarGradientState createState() => _VarGradientState();
}

class _VarGradientState extends State<VarGradient> {
  int index = 0;
  @override
  void initState() {
    super.initState();
    // defines a timer
    if (mounted) {
      Timer.periodic(Duration(milliseconds: 1200), (Timer t) {
        setState(() {
          if (index < 4) {
            index = index + 1;
          } else {
            index = 0;
          }
        });
      });
    }
  }

  List colorPalette = [
    [
      Color(0xFF90CAF9),
      Color(0xFF61A4F1),
      Color(0xFF478DE0),
      Color(0xFF398AE5)
    ],
    [
      Color(0xFFB2DFDB),
      Color(0xFF80CBC4),
      Color(0xFF4DB6AC),
      Color(0xFF009688)
    ],
    [
      Color(0xFFC5CAE9),
      Color(0xFF9FA8DA),
      Color(0xFF7986CB),
      Color(0xFF5C6BC0)
    ],
    [
      Color(0xFFE1BEE7),
      Color(0xFFCE93D8),
      Color(0xFFBA68C8),
      Color(0xFFAB47BC)
    ],
    [Color(0xFFD1C4E9), Color(0xFFB39DDB), Color(0xFF9575CD), Color(0xFF7E57C2)]
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: double.infinity,
      width: double.infinity,
      duration: Duration(seconds: 1),
      //child: Container(decoration: ,),
      curve: Curves.easeIn,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.1, 0.4, 0.7, 0.9],
        colors: colorPalette[index],
      )),
    );
  }
}
