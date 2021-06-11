import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sas_application/screens/log_in.dart';
import 'package:sas_application/Uniformity/var_gradient.dart';
import 'package:sas_application/firebase_services/auth.dart';
import 'package:sas_application/main.dart';
import '../Uniformity/widgets.dart';
import '../Uniformity/var_gradient.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Uniformity/style.dart';
import '../Uniformity/custom_validator.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: SignUp(
      inputData: 'data',
      auth: Auth(),
    ));
  }
}

class SignUp extends StatefulWidget {
  final String inputData;
  final AuthBase auth;
  //Constructor
  SignUp({Key? key, required this.inputData, required this.auth});

  @override
  State<StatefulWidget> createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  var myEmailController = TextEditingController();
  var myPasswordController = TextEditingController();
  var myNameController = TextEditingController();
  final globalFormKey = GlobalKey<FormState>();

  Future<void> _signInWithUserCredential() async {
    try {
      String _email = myEmailController.text.trim();
      String _password = myPasswordController.text.trim();
      await widget.auth.createUserWithEmailAndPassword(_email, _password);
      Navigator.push(
          context, MaterialPageRoute(builder: (builder) => LoginPage()));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Sign up Failed")));
      print(e.toString());
    }
  }

  // ignore: non_constant_identifier_names
  Widget signUpBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30.0),
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
          if (globalFormKey.currentState!.validate()) {
            _signInWithUserCredential();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Please Enter all Credentials")));
          }
        },
        child: Text(
          'SIGNUP',
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
            }, //Email validator
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

  Widget buildFullName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'FullName',
          style: labelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: boxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: myNameController,
            validator: (value) {
              return ValidateName(value!).validate();
            }, //Name validator
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              hintText: 'FullName',
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
          child: TextFormField(
            controller: myPasswordController,
            obscureText: true,
            validator: (value) {
              print(value);
              return ValidatePassword(value!).validation();
            },
            autovalidateMode:
                AutovalidateMode.onUserInteraction, //Password Validator
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

  @override
  void dispose() {
    myEmailController.dispose();
    myPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: globalFormKey,
      child: Scaffold(
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
                    padding: EdgeInsets.only(
                      right: 40.0,
                      left: 40.0,
                      top: 60.0,
                      bottom: 20.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        buildAppScreenLogo(),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        buildFullName(),
                        SizedBox(height: 20.0),
                        buildEmailLoginSignup(),
                        SizedBox(
                          height: 20.0,
                        ),
                        buildPasswordLoginSigup(),
                        signUpBtn(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
