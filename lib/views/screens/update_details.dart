import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:sas_application/uniformity/style.dart';
import 'package:sas_application/view_models/update_details_view_model.dart';
import 'package:sas_application/views/screens/user_profile.dart';
import 'package:stacked/stacked.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class UpdateDetails extends StatelessWidget {
  final String codeflag;
  final List initialDetails;
  const UpdateDetails(
      {Key? key, required this.codeflag, required this.initialDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UpdateDetailsViewModel>.reactive(
        builder: (context, viewModel, child) => MaterialApp(
              debugShowCheckedModeBanner: false,
              home: UpdateDetailsScreen(
                codeflag: codeflag,
                initialDetails: initialDetails,
                updateDetailsViewModel: viewModel,
              ),
            ),
        viewModelBuilder: () => UpdateDetailsViewModel());
  }
}

class UpdateDetailsScreen extends StatefulWidget {
  final List initialDetails;
  final String codeflag;
  final UpdateDetailsViewModel updateDetailsViewModel;

  UpdateDetailsScreen(
      {required this.updateDetailsViewModel,
      required this.codeflag,
      required this.initialDetails});

  @override
  _UpdateDetailsScreenState createState() => _UpdateDetailsScreenState();
}

class _UpdateDetailsScreenState extends State<UpdateDetailsScreen> {
  final globalFormKey = GlobalKey<FormState>();
  var myFirstNameController = TextEditingController();
  var myLastNameController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var ageController = TextEditingController();
  var genderController = TextEditingController();
  var myEmailController = TextEditingController();
  String email = "";
  String countryCode = "";
  String phone = "";
  String name = "";
  String gender = "";
  String code = "";
  String initialCode = "",
      initialPhone = "",
      initialEmail = "",
      initialGender = "";
  bool isphoneVerified = false;
  bool isEmailVerified = false;
  String radioItem = "";

  @override
  void initState() {
    super.initState();
    radioItem = widget.initialDetails[2].toString();
    BackButtonInterceptor.add(myInterceptor);
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    BackButtonInterceptor.remove(myInterceptor);
  }

  Widget buildAppScreenLogo() {
    return Container(
        child: Image.asset(
      'assets/logos/initial_app_screen_logo_1.png',
      height: 220.0,
      width: 220.0,
    ));
  }

  Widget buildBackButton() {
    return Container(
      alignment: Alignment.topLeft,
      child: TextButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserProfile()),
          );
        },
        icon: Icon(Icons.arrow_back_ios, color: Colors.blueAccent),
        label: Text(
          '',
          style: TextStyle(
            color: Colors.blueAccent,
            fontFamily: 'Open Sans',
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<List> getDetails() async {
    var details = await widget.updateDetailsViewModel.getInitialDetails();
    for (var detail in details) {
      myFirstNameController.text = detail['Name'].toString();
      myEmailController.text = detail['Email'].toString();
      phoneNumberController.text = detail['Phone']
          .toString()
          .substring(detail['Phone'].toString().length - 10);
      code = detail['Phone']
          .toString()
          .substring(0, detail['Phone'].toString().length - 10);
      initialPhone = detail['Phone'].toString();
      initialEmail = detail['Email'].toString();
      initialGender = detail['Gender'].toString();
    }

    return details;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
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
                                buildBackButton(),
                                buildAppScreenLogo(),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  ' Update Details',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontFamily: 'OpenSans',
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'Enter the details that you want to update.',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontFamily: 'OpenSans',
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 25.0),
                                FutureBuilder<List>(
                                    future: getDetails(),
                                    builder: (BuildContext context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      final docs = snapshot.data!;

                                      return ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: docs.length,
                                          itemBuilder: (ctx, index) {
                                            return GestureDetector(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    'Name',
                                                    style: userlabelStyle,
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  SizedBox(height: 5.0),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    decoration:
                                                        boxDecorationStyle,
                                                    height: 60.0,
                                                    child: TextFormField(
                                                      controller:
                                                          myFirstNameController,
                                                      validator: (value) {
                                                        return widget
                                                            .updateDetailsViewModel
                                                            .validateName(
                                                                value!);
                                                      },
                                                      //Name validator
                                                      autovalidateMode:
                                                          AutovalidateMode
                                                              .onUserInteraction,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF527DAA),
                                                        fontFamily: 'OpenSans',
                                                      ),
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        errorStyle: errorStyle,
                                                        contentPadding:
                                                            EdgeInsets.fromLTRB(
                                                                20.0,
                                                                14.0,
                                                                20.0,
                                                                14.0),
                                                        prefixIcon: Icon(
                                                          Icons.person,
                                                          color:
                                                              Color(0xFF527DAA),
                                                        ),
                                                        hintText:
                                                            'Enter Your Name',
                                                        hintStyle:
                                                            hintTextStyle,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 15.0),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Text(
                                                            'Contact Number',
                                                            style:
                                                                userlabelStyle,
                                                          ),
                                                          TextButton(
                                                            style: TextButton.styleFrom(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            100.0)),
                                                            onPressed: () => {
                                                              if (phoneNumberController
                                                                  .text
                                                                  .isNotEmpty)
                                                                {
                                                                  phone = code +
                                                                      phoneNumberController
                                                                          .text
                                                                          .toString(),
                                                                  if (initialPhone ==
                                                                      phone)
                                                                    {
                                                                      isphoneVerified =
                                                                          true,
                                                                    },
                                                                  print(
                                                                      initialPhone),
                                                                  print(phone),
                                                                  if (isphoneVerified ==
                                                                      true)
                                                                    {
                                                                      showPlatformDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return BasicDialogAlert(
                                                                              content: Text("Your phone number is already verified"),
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
                                                                  else
                                                                    {
                                                                      widget.updateDetailsViewModel.verifyPhoneNumber(
                                                                          phone,
                                                                          context)
                                                                    }
                                                                }
                                                              else
                                                                {
                                                                  showPlatformDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (context) {
                                                                        return BasicDialogAlert(
                                                                          content:
                                                                              Text("Please Enter both, Contact Number and Country code"),
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
                                                                color:
                                                                    Colors.red,
                                                                letterSpacing:
                                                                    1.5,
                                                                fontSize: 12.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'OpenSans',
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                      //SizedBox(height: 5.0),
                                                      Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        decoration:
                                                            boxDecorationStyle,
                                                        height: 60.0,
                                                        child: IntlPhoneField(
                                                          initialCountryCode:
                                                              widget.codeflag,
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            errorStyle:
                                                                errorStyle,
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .fromLTRB(
                                                                        20.0,
                                                                        14.0,
                                                                        20.0,
                                                                        14.0),
                                                            hintText:
                                                                'Contact Number',
                                                            hintStyle:
                                                                hintTextStyle,
                                                          ),
                                                          controller:
                                                              phoneNumberController,
                                                          autoValidate: true,
                                                          onChanged: (Phone) {
                                                            print(Phone
                                                                .completeNumber);
                                                          },
                                                          onCountryChanged:
                                                              (Phone) {
                                                            print('Country code changed to: ' +
                                                                Phone
                                                                    .countryCode
                                                                    .toString());
                                                            countryCode = Phone
                                                                .countryCode
                                                                .toString();
                                                            code = countryCode;
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 15.0),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
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
                                                            radioItem =
                                                                val.toString();
                                                          });
                                                        },
                                                      ),
                                                      RadioListTile(
                                                        groupValue: radioItem,
                                                        title: Text('Female'),
                                                        value: 'Female',
                                                        onChanged: (val) {
                                                          setState(() {
                                                            radioItem =
                                                                val.toString();
                                                          });
                                                        },
                                                      ),
                                                      RadioListTile(
                                                        groupValue: radioItem,
                                                        title: Text(
                                                            'Third Gender'),
                                                        value: 'Third Gender',
                                                        onChanged: (val) {
                                                          setState(() {
                                                            radioItem =
                                                                val.toString();
                                                          });
                                                        },
                                                      ),
                                                      RadioListTile(
                                                        groupValue: radioItem,
                                                        title: Text(
                                                            'Not preferred to reveal'),
                                                        value:
                                                            'Not preferred to reveal',
                                                        onChanged: (val) {
                                                          setState(() {
                                                            radioItem =
                                                                val.toString();
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 30.0),
                                                    width: double.infinity,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary:
                                                            Colors.blueGrey,
                                                        onPrimary: Colors.white,
                                                        elevation: 10.0,
                                                        padding: EdgeInsets.all(
                                                            15.0),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30.0),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        name =
                                                            myFirstNameController
                                                                .text;
                                                        gender = radioItem;

                                                        print(countryCode);
                                                        print(code);
                                                        phone = code +
                                                            phoneNumberController
                                                                .text;
                                                        print(phone);
                                                        print(initialPhone);

                                                        if (phone ==
                                                            initialPhone) {
                                                          isphoneVerified =
                                                              true;
                                                        } else {
                                                          isphoneVerified =
                                                              false;
                                                        }
                                                        List<String> details = [
                                                          name,
                                                          phone,
                                                          gender
                                                        ];
                                                        print(isphoneVerified);

                                                        if (globalFormKey
                                                            .currentState!
                                                            .validate()) {
                                                          if (widget
                                                                  .updateDetailsViewModel
                                                                  .auth
                                                                  .isPhoneVerified ==
                                                              true) {
                                                            widget
                                                                .updateDetailsViewModel
                                                                .updateUser(
                                                                    details,
                                                                    this.context);
                                                          } else if (isphoneVerified ==
                                                              true) {
                                                            widget
                                                                .updateDetailsViewModel
                                                                .updateUser(
                                                                    details,
                                                                    this.context);
                                                          } else {
                                                            showPlatformDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return BasicDialogAlert(
                                                                    title: Text(
                                                                        "Phone Verification"),
                                                                    content: Text(
                                                                        "Please verify your phone number first."),
                                                                    actions: [
                                                                      BasicDialogAction(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          title:
                                                                              Text("OK"))
                                                                    ],
                                                                  );
                                                                });
                                                          }
                                                        } else {
                                                          showPlatformDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return BasicDialogAlert(
                                                                  title: Text(
                                                                      "Enter proper details"),
                                                                  content: Text(
                                                                      "Please check the format and values of text fields."),
                                                                  actions: [
                                                                    BasicDialogAction(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        title: Text(
                                                                            "OK"))
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              'OpenSans',
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          });
                                    })
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))),
        onWillPop: () async => false);
  }
}
