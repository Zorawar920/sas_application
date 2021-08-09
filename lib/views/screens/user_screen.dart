import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sas_application/uniformity/style.dart';
import 'package:sas_application/view_models/user_screen_view_model.dart';
import 'package:stacked/stacked.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserScreenViewModel>.reactive(
        builder: (context, viewModel, child) => MaterialApp(
              debugShowCheckedModeBanner: false,
              home: UserScreenApp(
                userScreenViewModel: viewModel,
              ),
            ),
        viewModelBuilder: () => UserScreenViewModel());
  }
}

class UserScreenApp extends StatefulWidget {
  final UserScreenViewModel userScreenViewModel;

  UserScreenApp({required this.userScreenViewModel});
  @override
  State<StatefulWidget> createState() => UserScreenState();
}

class UserScreenState extends State<UserScreenApp> {
  final globalFormKey = GlobalKey<FormState>();
  var myFirstNameController = TextEditingController();
  var myLastNameController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var ageController = TextEditingController();
  var genderController = TextEditingController();
  var myEmailController = TextEditingController();
  String email = FirebaseAuth.instance.currentUser!.email.toString();
  String dropdownValue = "";
  String holder = "";
  String phone = "";
  String name = "";
  String code ="";
  String countryCode = "";
  String radioItem = "";

  @override
  void initState() {
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

  Widget buildAppScreenLogo() {
    return Container(
        child: Image.asset(
      'assets/logos/initial_app_screen_logo_1.png',
      height: 220.0,
      width: 220.0,
    ));
  }

  Widget buildGender() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Gender',
          style: userlabelStyle,
        ),
        SizedBox(height: 5.0),
        RadioListTile(
          groupValue: radioItem,
          title: Text('Male'),
          value: 'Male',
          onChanged: (val) {
            setState(() {
              radioItem = val.toString();
            });
          },
        ),

        RadioListTile(
          groupValue: radioItem,
          title: Text('Female'),
          value: 'Female',
          onChanged: (val) {
            setState(() {
              radioItem = val.toString();
            });
          },
        ),
        RadioListTile(
          groupValue: radioItem,
          title: Text('Third Gender'),
          value: 'Third Gender',
          onChanged: (val) {
            setState(() {
              radioItem = val.toString();
            });
          },
        ),
        RadioListTile(
          groupValue: radioItem,
          title: Text('Not preferred to reveal'),
          value: 'Not preferred to reveal',
          onChanged: (val) {
            setState(() {
              radioItem = val.toString();
            });
          },
        ),

      ],
    );
  }



  Widget submitBtn(BuildContext context) {
    phone = code + phoneNumberController.text.toString();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.blueGrey,
          onPrimary: Colors.white,
          elevation: 10.0,
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: () async {
          if(globalFormKey.currentState!.validate() && radioItem !="") {
            if (widget.userScreenViewModel.auth
                .isPhoneVerified == true) {
              showPlatformDialog(
                  context: context,
                  builder: (context) {
                    return BasicDialogAlert(
                      title: Text("Terms and Conditions"),
                      content: Text(
                          "We care about your privacy and think it is important that you know why and how we collect your data in accordance with applicable data protection and provacy laws.\n"
                              "We collect personal information like name, email, phone number and location in case of SOS call.\n"
                              "We will retain your data for 3 years from the last date you use this application and data will be shared with third party APIs.\n"
                              "\nIf you do not agree to these terms, you will not be able to use this application."),
                      actions: [
                        BasicDialogAction(
                            onPressed: () {
                              widget.userScreenViewModel.updateUser(
                                  phone, radioItem, code, this.context);
                            },
                            title: Text("I Agree")),
                        BasicDialogAction(
                            onPressed: () {
                              Navigator.of(this.context).pop();
                            },
                            title: Text("I do not agree"))
                      ],
                    );
                  });
            }
            else {
              showPlatformDialog(
                  context: context,
                  builder: (context) {
                    return BasicDialogAlert(
                      title: Text("Phone Verification"),
                      content: Text(
                          "Please verify your phone number first."),
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
          }
          else {
            showPlatformDialog(
                context: context,
                builder: (context) {
                  return BasicDialogAlert(
                    title: Text("Missing Details"),
                    content: Text(
                        "Please Enter all Details"),
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
          'SUBMIT',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget buildPhone()  {
    //getInitialCode(code);
    code = "+1";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              'Contact Number',
              style: userlabelStyle,
            ),
            TextButton(
              style:
              TextButton.styleFrom(padding: EdgeInsets.only(left: 100.0)),
              onPressed: () =>
              {
                if (phoneNumberController.text.isNotEmpty)
                  {
                    phone = code+phoneNumberController.text.toString(),
                        widget.userScreenViewModel.verifyPhoneNumber(
                            phone, context)
                  }
                else
                  {
                    showPlatformDialog(
                        context: context,
                        builder: (context) {
                          return BasicDialogAlert(
                            content: Text(
                                "Please Enter both, Contact Number and Country code"),
                            actions: [
                              BasicDialogAction(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  title: Text("OK"))
                            ],
                          );
                        })
                  }
              },
              child: Text(
                'Verify',
                style: TextStyle(
                  color: Colors.red,
                  letterSpacing: 1.5,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
          ],
        ),

        //SizedBox(height: 5.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: boxDecorationStyle,
          height: 60.0,
          child: IntlPhoneField(
            initialCountryCode: "CA",
            decoration: InputDecoration(
              border: InputBorder.none,
              errorStyle: errorStyle,
              contentPadding:
              EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 14.0),
              hintText: 'Contact Number',
              hintStyle: hintTextStyle,
            ),
            controller: phoneNumberController,
            autoValidate: true,
            onChanged: (Phone) {
              print(Phone.completeNumber);
            },
            onCountryChanged: (Phone) {
              print(
                  'Country code changed to: ' + Phone.countryCode.toString());
              countryCode = Phone.countryCode.toString();
              code = countryCode;
            },
          ),),
      ],
    );
  }

  Widget signOutBtn(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.0),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.blueGrey,
          onPrimary: Colors.white,
          elevation: 10.0,
          padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: () async {
          widget.userScreenViewModel.signOutAnonymously(context);
        },
        child: Text(
          'Log Out',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child:
      Scaffold(
      body: Form(
        key: globalFormKey,
        child: Scaffold(
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(
                      right: 40.0,
                      left: 40.0,
                      top: 60.0,
                      bottom: 30.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        buildAppScreenLogo(),
                        SizedBox(
                          height: 10.0,
                        ),
                        Center(
                          child: Text(
                            ' Additional User Details',
                            style: TextStyle(
                              color: Colors.blue,
                              fontFamily: 'OpenSans',
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 15.0),
                        buildGender(),
                        SizedBox(height: 15.0),
                        buildPhone(),
                        SizedBox(height: 15.0),
                        submitBtn(context),
                        signOutBtn(context)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
    onWillPop: () async => false);
  }
}
