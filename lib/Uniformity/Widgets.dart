import 'package:flutter/material.dart';
import './style.dart';
// ignore: unused_import

Widget buildForgotPasswordBtn() {
  return Container(
    alignment: Alignment.centerRight,
    child: TextButton(
      style: TextButton.styleFrom(padding: EdgeInsets.only(right: 0.0)),
      onPressed: () => print('Forgot Password Button Pressed'),
      child: Text(
        'Forgot Password?',
        style: labelStyle,
      ),
    ),
  );
}

Widget buildSignInWithText() {
  return Column(
    children: <Widget>[
      Text(
        '- OR -',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
      ),
      SizedBox(height: 20.0),
      Text(
        'Sign in with',
        style: labelStyle,
      ),
    ],
  );
}

Widget buildSocialBtn(Function onTap, AssetImage logo) {
  return GestureDetector(
    onTap: onTap(),
    child: Container(
      height: 60.0,
      width: 60.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 6.0,
          ),
        ],
        image: DecorationImage(
          image: logo,
        ),
      ),
    ),
  );
}

Widget buildSocialBtnRow() {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 30.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        buildSocialBtn(
          () => print('Login with Google'),
          AssetImage(
            'assets/logos/google.jpg',
          ),
        ),
      ],
    ),
  );
}

Widget buildSignupBtn() {
  return GestureDetector(
    onTap: () => print('Sign Up Button Pressed'),
    child: RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Don\'t have an Account? ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: 'Sign Up',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}
