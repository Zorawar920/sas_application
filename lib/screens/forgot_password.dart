import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sas_application/Uniformity/Widgets.dart';
import '../Uniformity/var_gradient.dart';
import '../Uniformity/style.dart';
import '../firebase_services/auth.dart';
import '../Uniformity/custom_validator.dart';

class ForgotPage extends StatelessWidget {
  const ForgotPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ForgotPassword(
        auth: Auth(),
        id: 'Forgot Password',
      ),
    );
  }
}

class ForgotPassword extends StatefulWidget {
  final String id;
  final AuthBase auth;

  ForgotPassword({Key? key, required this.id, required this.auth});

  @override
  State<ForgotPassword> createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  var myEmailController = TextEditingController();
  final globalKey = GlobalKey<FormState>();

  String get email => myEmailController.text;
  Future<void> _sendResetPasswordMail() async {
    try {
      await widget.auth.signInWithEmailAndPassword(email, 'password');
      await widget.auth.currentUser!.reload();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          final snackBar =
              SnackBar(content: Text('This Email is invalid: $email'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
        case "wrong-password":
          final snackBar =
              SnackBar(content: Text('Reset Password Email is sent to $email'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          await widget.auth.forgotPasswordWithEmail(email);
          Navigator.pop(context, true);
          break;
        case "user-not-found":
          final snackBar = SnackBar(
              content: Text('This Email does not exist in system: $email'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
      }
    }
  }

  Widget signUpBtn() {
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
          if (globalKey.currentState!.validate()) {
            _sendResetPasswordMail();
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Enter valid Email")));
          }
        },
        child: Text(
          'Send Email',
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
          child: TextFormField(
            controller: myEmailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              return ValidateEmail(value!).validate();
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.lightBlueAccent,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              VarGradient(),
              Form(
                key: globalKey,
                child: Padding(
                  padding: EdgeInsets.only(right: 40.0,
                    left: 40.0,
                    top: 20.0,
                    bottom: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      buildAppScreenLogo(),
                      SizedBox(height: 40),
                      Text(
                        'Forgot Password',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      buildEmailLoginSignup(),
                      signUpBtn(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
