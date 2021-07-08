import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:sas_application/uniformity/Widgets.dart';
import 'package:sas_application/uniformity/style.dart';
import 'package:sas_application/uniformity/var_gradient.dart';
import 'package:sas_application/view_models/forgot_password_view_model.dart';
import 'package:sas_application/views/screens/log_in.dart';
import 'package:stacked/stacked.dart';

import '../../singleton_instance.dart';

class ForgotPage extends StatelessWidget {
  const ForgotPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForgotPasswordViewModel>.reactive(
        builder: (context, viewModel, child) => MaterialApp(
              debugShowCheckedModeBanner: false,
              home: ForgotPassword(
                forgotPasswordViewModel: viewModel,
                id: "Login State",
                key: key,
              ),
            ),
        viewModelBuilder: () => ForgotPasswordViewModel());
  }
}

class ForgotPassword extends StatefulWidget {
  final String id;
  final ForgotPasswordViewModel forgotPasswordViewModel;

  ForgotPassword(
      {Key? key, required this.id, required this.forgotPasswordViewModel});

  @override
  State<ForgotPassword> createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  final VarGradient _varGradient = singletonInstance<VarGradient>();
  var myEmailController = TextEditingController();
  final globalKey = GlobalKey<FormState>();

  String get email => myEmailController.text;

  Widget signUpBtn(BuildContext context) {
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
            widget.forgotPasswordViewModel
                .sendResetPasswordMail(email, context);
          } else {
            showPlatformDialog(
                context: context,
                builder: (context) {
                  return BasicDialogAlert(
                    title: Text("Invalid E-mail"),
                    content: Text("Enter valid Email"),
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

  Widget buildRememberPasswordBtn(BuildContext context) {
    return Container(
      //alignment: Alignment.centerRight,
      child: TextButton(
        style: TextButton.styleFrom(padding: EdgeInsets.only(right: 0.0)),
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          )
        },
        child: Text(
          'Remember Password?',
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
              return widget.forgotPasswordViewModel.validateEmail(value!);
            },
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

  @override
  void initState() {
    //State Management for Widgets
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    return true;
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
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
              _varGradient,
              Form(
                key: globalKey,
                child: Padding(
                  padding: EdgeInsets.only(
                      right: 40.0, left: 40.0, top: 20.0, bottom: 20.0),
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
                      signUpBtn(context),
                      SizedBox(height: 10.0),
                      buildRememberPasswordBtn(context)
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
