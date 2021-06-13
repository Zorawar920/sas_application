import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sas_application/screens/sign_up.dart';
import 'package:sas_application/Uniformity/var_gradient.dart';
import 'package:sas_application/user_status.dart';
import '../Uniformity/var_gradient.dart';
import '../Uniformity/style.dart';
import 'forgot_password.dart';
import '../Uniformity/widgets.dart';
import '../Uniformity/custom_validator.dart';
import 'package:sas_application/firebase_services/auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserStatus(
        auth: Auth(),
      ),
    );
  }
}

class LogIn extends StatefulWidget {
  final String inputData;
  final AuthBase auth;
  //Constructor
  LogIn(String s, {Key? key, required this.inputData, required this.auth});

  @override
  State<StatefulWidget> createState() => LogInState();
}

class LogInState extends State<LogIn> {
  var myEmailController = TextEditingController();
  var myPasswordController = TextEditingController();
  bool _isLoading = false;
  final globalKey = GlobalKey<FormState>();

  //Constructor

  Future<void> _signInAnonymously() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await widget.auth.signInAnonymously();
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signWithGoogle() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await widget.auth.signInWithGoogle();
      final snackBar = SnackBar(content: Text('Sign in to Google successful'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithUserCredentials() async {
    try {
      String _email = myEmailController.text;
      String _password = myPasswordController.text;
      await widget.auth.signInWithEmailAndPassword(_email, _password);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invalid Email or Password")));
      print(e.toString());
    }
  }

  // Google Sign In
  Widget loginWithGoogleBtn() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0),
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

  Widget buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: _signWithGoogle,
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

  // ignore: non_constant_identifier_names
  Widget LogInBtn(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
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
            _signInWithUserCredentials();
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Enter All Credentials")));
          }
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

  Widget buildNoAccountSignupBtn() {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context, MaterialPageRoute(builder: (builder) => SignUpPage()))
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
          child: TextFormField(
            controller: myEmailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              return ValidateEmail(value!).validate();
            }, //Email Validator
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              errorStyle: labelStyle,
              contentPadding: EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 14.0),
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
          child: TextFormField(
            controller: myPasswordController,
            obscureText: true,
            validator: (value) {
              return ValidatePassword(value!).validation();
            }, //Password Validator
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              errorStyle: labelStyle,
              contentPadding: EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 14.0),
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
            MaterialPageRoute(builder: (context) => ForgotPage()),
          )
        },
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
    return Form(
      key: globalKey,
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
                        _buildHeader(),
                        SizedBox(height: 20.0),
                        buildEmailLoginSignup(),
                        SizedBox(
                          height: 20.0,
                        ),
                        buildPasswordLoginSigup(),
                        buildForgotPasswordBtn(),
                        LogInBtn(context),
                        buildSignInWithText(),
                        loginWithGoogleBtn(),
                        buildNoAccountSignupBtn(),
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

  Widget _buildHeader() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      'Login',
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'OpenSans',
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
