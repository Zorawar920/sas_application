import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './Uniformity/VarGradient.dart';
import 'Uniformity/style.dart';


class ForgotPassword extends StatefulWidget {
  static String id = 'forgot-password';


  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  var myEmailController = TextEditingController();

  Widget PopBackSignIn(){
    return Container(
      //padding: EdgeInsets.symmetric(vertical: 5.0),
        child:TextButton(

          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Sign In',
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 1.5,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        )
    );
  }


  Widget SignUpBtn() {
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

  @override
  Widget build(BuildContext context) {
    var _email;
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
                child: Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Forgot Password',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      buildEmailLoginSignup(),
                      // Text('Enter Your Email', style: TextStyle(fontSize: 30, color: Colors.white, ),
                      // ),
                      // TextFormField(
                      //   style: TextStyle(color: Colors.white),
                      //   decoration: InputDecoration(
                      //     labelText: 'Email',
                      //     icon: Icon(
                      //       Icons.mail,
                      //       color: Colors.white,
                      //     ),
                      //     errorStyle: TextStyle(color: Colors.white),
                      //     labelStyle: TextStyle(color: Colors.white),
                      //     hintStyle: TextStyle(color: Colors.white),
                      //     focusedBorder: UnderlineInputBorder(
                      //       borderSide: BorderSide(color: Colors.white),
                      //     ),
                      //     enabledBorder: UnderlineInputBorder(
                      //       borderSide: BorderSide(color: Colors.white),
                      //     ),
                      //     errorBorder: UnderlineInputBorder(
                      //       borderSide: BorderSide(color: Colors.white),
                      //     ),
                      //   ),
                      //   onSaved: (newEmail) {
                      //     _email = newEmail;
                      //   },
                      // ),
                      SizedBox(height: 20),
                      SignUpBtn(),
                      // RaisedButton(
                      //  // child: Text('Send Email'),
                      //   onPressed: () {
                      //   },
                      // ),
                      // FlatButton(
                      //   child: Text('Sign In'),
                      //   onPressed: () {
                      //     Navigator.pop(context);
                      //   },
                      //)
                      PopBackSignIn(),
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