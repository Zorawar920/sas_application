import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sas_application/Signup.dart';
import 'package:sas_application/Uniformity/VarGradient.dart';
import './Uniformity/Widgets.dart';
import './Uniformity/VarGradient.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './Uniformity/style.dart';
import 'ForgotPassword.dart';

class Login extends StatefulWidget {
  final String inputData;
  //Constructor
  Login(String s, {Key? key, required this.inputData});

  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<Login> {
  var myEmailController = TextEditingController();
  var myPasswordController = TextEditingController();

  // ignore: non_constant_identifier_names
  Widget LoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: Colors.blueGrey,
          elevation: 10.0,
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: () {
          //Code goes here for login
          showDialog(
            context: context,
            builder: (conttext) {
              return AlertDialog(
                content: Text(myEmailController.text),
              );
            },
          );
        },
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget buildSocialBtn(AssetImage logo) {
    return GestureDetector(
      onTap: () =>
          {print("Googe Support Added")}, //Google SignIn Logic goes here
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 30.0),
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
      ),
    );
  }

  Widget buildNoAccountSignupBtn() {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => Signup(
                      inputData: "Added",
                    )))
      },
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

  Widget buildEmailLoginSignup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: labelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: boxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: myEmailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
              hintStyle: hintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPasswordLoginSigup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: labelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: boxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: myPasswordController,
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
              hintStyle: hintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildForgotPasswordBtn() {
    return Container(
      //alignment: Alignment.centerRight,
      child: TextButton(
        style: TextButton.styleFrom(padding: EdgeInsets.only(right: 0.0)),
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ForgotPassword()),
          )
        }, //Your Navigator goes here
        child: Text(
          'Forgot Password?',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    myEmailController.dispose();
    myPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              VarGradient(),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      buildEmailLoginSignup(),
                      SizedBox(
                        height: 30.0,
                      ),
                      buildPasswordLoginSigup(),
                      LoginBtn(),
                      buildForgotPasswordBtn(),
                      buildSignInWithText(),
                      buildSocialBtn(
                        AssetImage(
                          'assets/logos/google.jpg',
                        ),
                      ),
                      buildNoAccountSignupBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
