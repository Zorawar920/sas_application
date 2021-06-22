import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sas_application/uniformity/CustomBottomNavBar.dart';
import 'package:sas_application/uniformity/style.dart';
import 'package:sas_application/view_models/user_screen_view_model.dart';
import 'package:stacked/stacked.dart';

import '../../enums.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
  var emergencyController1 = TextEditingController();
  var emergencyController2 = TextEditingController();
  var emergencyController3 = TextEditingController();
  var emergencyController4 = TextEditingController();
  var emergencyController5 = TextEditingController();

  Widget buildAppScreenLogo() {
    return Container(
        child: Image.asset(
      'assets/logos/initial_app_screen_logo_1.png',
      height: 220.0,
      width: 220.0,
    ));
  }

  Widget buildFirstName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'First Name',
          style: UserlabelStyle,
        ),
        SizedBox(height: 5.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: boxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: myFirstNameController,
            validator: (value) {
              return widget.userScreenViewModel.validateName(value!);
            }, //Name validator
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Color(0xFF527DAA),
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              errorStyle: errorStyle,
              contentPadding: EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 14.0),
              prefixIcon: Icon(
                Icons.person,
                color: Color(0xFF527DAA),
              ),
              hintText: 'Enter Your First Name',
              hintStyle: hintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLastName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Last Name',
          style: UserlabelStyle,
        ),
        SizedBox(height: 5.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: boxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: myLastNameController,
            validator: (value) {
              return widget.userScreenViewModel.validateName(value!);
            }, //Name validator
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Color(0xFF527DAA),
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              errorStyle: errorStyle,
              contentPadding: EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 0.0),
              prefixIcon: Icon(
                Icons.person,
                color: Color(0xFF527DAA),
              ),
              hintText: 'Enter Your Last Name',
              hintStyle: hintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildGender() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Gender',
          style: UserlabelStyle,
        ),
        SizedBox(height: 5.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: boxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: genderController,
            validator: (value) {
              return widget.userScreenViewModel.validateGender(value!);
            }, //Name validator
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
                Icons.person_pin,
                color: Color(0xFF527DAA),
              ),
              hintText: 'Enter Male, Female or other',
              hintStyle: hintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPhoneNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Contact Number',
          style: UserlabelStyle,
        ),
        SizedBox(height: 5.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: boxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: phoneNumberController,
            validator: (value) {
              return widget.userScreenViewModel.validatePhone(value!);
            }, //Name validator
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.phone,
            style: TextStyle(
              color: Color(0xFF527DAA),
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              errorStyle: errorStyle,
              contentPadding: EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 14.0),
              prefixIcon: Icon(
                Icons.phone,
                color: Color(0xFF527DAA),
              ),
              hintText: ' Enter Your Contact Number',
              hintStyle: hintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildAge() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Age',
          style: UserlabelStyle,
        ),
        SizedBox(height: 5.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: boxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: ageController,
            keyboardType: TextInputType.number,
            validator: (value) {
              return widget.userScreenViewModel.validateAge(value!);
            }, //Name validator
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
                Icons.person,
                color: Color(0xFF527DAA),
              ),
              hintText: 'Enter your Age',
              hintStyle: hintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildEContact1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Emergency Contact 1',
          style: UserlabelStyle,
        ),
        SizedBox(height: 5.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: boxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: emergencyController1,
            validator: (value) {
              return widget.userScreenViewModel.validatePhone(value!);
            }, //Name validator
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.phone,
            style: TextStyle(
              color: Color(0xFF527DAA),
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              errorStyle: errorStyle,
              contentPadding: EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 14.0),
              prefixIcon: Icon(
                Icons.phone,
                color: Color(0xFF527DAA),
              ),
              hintText: ' Enter Emergency Contact',
              hintStyle: hintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildEContact2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Emergency Contact 2',
          style: UserlabelStyle,
        ),
        SizedBox(height: 5.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: boxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: emergencyController2,
            validator: (value) {
              return widget.userScreenViewModel.validateEContact(value!);
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.phone,
            style: TextStyle(
              color: Color(0xFF527DAA),
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              errorStyle: errorStyle,
              contentPadding: EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 14.0),
              prefixIcon: Icon(
                Icons.phone,
                color: Color(0xFF527DAA),
              ),
              hintText: ' Enter Emergency Contact',
              hintStyle: hintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildEContact3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Emergency Contact 3',
          style: UserlabelStyle,
        ),
        SizedBox(height: 5.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: boxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: emergencyController3,
            validator: (value) {
              return widget.userScreenViewModel.validateEContact(value!);
            }, //Name validator
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.phone,
            style: TextStyle(
              color: Color(0xFF527DAA),
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              errorStyle: errorStyle,
              contentPadding: EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 14.0),
              prefixIcon: Icon(
                Icons.phone,
                color: Color(0xFF527DAA),
              ),
              hintText: ' Enter Emergency Contact',
              hintStyle: hintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildEContact4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Emergency Contact 4',
          style: UserlabelStyle,
        ),
        SizedBox(height: 5.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: boxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: emergencyController4,
            validator: (value) {
              return widget.userScreenViewModel.validateEContact(value!);
            }, //Name validator
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.phone,
            style: TextStyle(
              color: Color(0xFF527DAA),
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              errorStyle: errorStyle,
              contentPadding: EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 14.0),
              prefixIcon: Icon(
                Icons.phone,
                color: Color(0xFF527DAA),
              ),
              hintText: ' Enter Emergency Contact',
              hintStyle: hintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildEContact5() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Emergency Contact 5',
          style: UserlabelStyle,
        ),
        SizedBox(height: 5.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: boxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: emergencyController5,
            validator: (value) {
              return widget.userScreenViewModel.validateEContact(value!);
            }, //Name validator
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.phone,
            style: TextStyle(
              color: Color(0xFF527DAA),
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              errorStyle: errorStyle,
              contentPadding: EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 14.0),
              prefixIcon: Icon(
                Icons.phone,
                color: Color(0xFF527DAA),
              ),
              hintText: ' Enter Emergency Contact',
              hintStyle: hintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget submitBtn(BuildContext context) {
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
        onPressed: () {},
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

  Widget signOutBtn(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.blueGrey,
          onPrimary: Colors.white,
          elevation: 10.0,
          padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: () async {
          widget.userScreenViewModel.signOutAnonymously(context);
        },
        child: Text(
          'LogOut',
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
    // TODO: implement build
    return Scaffold(
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
                        Text(
                          'User Details',
                          style: TextStyle(
                            color: Colors.blue,
                            fontFamily: 'OpenSans',
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 25.0),
                        buildFirstName(),
                        SizedBox(height: 15.0),
                        buildLastName(),
                        SizedBox(height: 15.0),
                        buildPhoneNumber(),
                        SizedBox(height: 15.0),
                        buildGender(),
                        SizedBox(height: 15.0),
                        buildAge(),
                        SizedBox(height: 15.0),
                        buildEContact1(),
                        SizedBox(height: 15.0),
                        buildEContact2(),
                        SizedBox(height: 15.0),
                        buildEContact3(),
                        //SizedBox(height: 15.0),
                        //buildEContact4(),
                        //SizedBox(height: 15.0),
                        //buildEContact5(),
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
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
    );
  }
}
