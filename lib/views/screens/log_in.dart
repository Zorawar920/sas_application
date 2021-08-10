import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:sas_application/singleton_instance.dart';
import 'package:sas_application/uniformity/custom_widget.dart';
import 'package:sas_application/uniformity/style.dart';
import 'package:sas_application/uniformity/var_gradient.dart';
import 'package:sas_application/view_models/login_view_model.dart';
import 'package:sas_application/views/screens/sign_up.dart';
import 'package:stacked/stacked.dart';
import 'forgot_password.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
        builder: (context, viewModel, child) => MaterialApp(
              debugShowCheckedModeBanner: false,
              home: LogIn(
                loginViewModel: viewModel,
                inputData: "Login State",
                key: key,
              ),
            ),
        viewModelBuilder: () => LoginViewModel());
  }
}

class LogIn extends StatefulWidget {
  final String inputData;
  final LoginViewModel loginViewModel;

  //Constructor
  LogIn({Key? key, required this.inputData, required this.loginViewModel});

  @override
  State<StatefulWidget> createState() => LogInState();
}

class LogInState extends State<LogIn> {
  final VarGradient _varGradient = singletonInstance<VarGradient>();
  var myEmailController = TextEditingController();
  var myPasswordController = TextEditingController();
  final globalKey = GlobalKey<FormState>();

  Widget buildSocialBtn(BuildContext context, Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: () async {
        widget.loginViewModel.signInWithGoogle(context);
        showPlatformDialog(
            context: context,
            builder: (context) => FutureProgressDialog(
                widget.loginViewModel.getFuture(),
                message: Text('Signing in With Google...')));
      },
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
            widget.loginViewModel.signInWithUserCredentials(
                myEmailController, myPasswordController, context);
            showPlatformDialog(
                context: context,
                builder: (context) => FutureProgressDialog(
                    widget.loginViewModel.getFuture(),
                    message: Text('Signing in...')));
          } else {
            showPlatformDialog(
                context: context,
                builder: (context) {
                  return BasicDialogAlert(
                    title: Text("Invalid Credentials"),
                    content: Text("Please enter valid credentials"),
                    actions: [
                      BasicDialogAction(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          title: Text("OK"))
                    ],
                  );
                });
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
              return widget.loginViewModel.validateEmail(value!);
            },
            //Email Validator
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: TextStyle(
              color: Color(0xFF527DAA),
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              errorStyle: errorStyle,
              contentPadding: EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Color(0xFF527DAA),
              ),
              hintText: 'Enter your Email',
              hintStyle: hintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPasswordLoginSignup() {
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
              return widget.loginViewModel.validatePassword(value!);
            },
            //Password Validator
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: TextStyle(
              color: Color(0xFF527DAA),
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              errorStyle: errorStyle,
              contentPadding: EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Color(0xFF527DAA),
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
  void initState() {
    //State Management for Widgets
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Back Button Pressed")));
    return true;
  }

  @override
  void dispose() {
    myEmailController.dispose();
    myPasswordController.dispose();
    BackButtonInterceptor.remove(myInterceptor);
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
                _varGradient,
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
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        buildEmailLoginSignup(),
                        SizedBox(
                          height: 20.0,
                        ),
                        buildPasswordLoginSignup(),
                        buildForgotPasswordBtn(),
                        LogInBtn(context),
                        buildSignInWithText(),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              buildSocialBtn(
                                context,
                                () => print('Login with Google'),
                                AssetImage(
                                  'assets/logos/google.jpg',
                                ),
                              ),
                            ],
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
      ),
    );
  }
}
