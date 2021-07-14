import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sas_application/uniformity/custom_bottom_nav_bar.dart';
import 'package:sas_application/uniformity/style.dart';
import 'package:sas_application/view_models/user_profile_view_model.dart';
import 'package:sas_application/views/screens/emergency_contact.dart';
import 'package:sas_application/views/screens/user_screen.dart';
import 'package:stacked/stacked.dart';

import '../../enums.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserProfileViewModel>.reactive(
        builder: (context, viewModel, child) => MaterialApp(
              debugShowCheckedModeBanner: false,
              home: UserProfileScreen(
                userProfileViewModel: viewModel,
              ),
            ),
        viewModelBuilder: () => UserProfileViewModel());
  }
}

class UserProfileScreen extends StatefulWidget {
  final UserProfileViewModel userProfileViewModel;

  UserProfileScreen({required this.userProfileViewModel});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String name = "";
  String number = "";
  String email = "";
  String gender = "";

  void initState() {
    super.initState();
    userDetails();
  }

  Widget buildAppScreenLogo() {
    return Container(
        child: Image.asset(
      'assets/logos/initial_app_screen_logo_1.png',
      height: 220.0,
      width: 220.0,
    ));
  }

  Widget buildPersonalDetails() {
    return Container(
        alignment: Alignment.centerLeft,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Personal Details',
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontFamily: 'Open Sans',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (builder) => UserScreen()));
                  },
                  icon: Icon(Icons.edit),
                  color: Colors.blueGrey,
                )
              ],
            ),
            SizedBox(height: 10.0),
            Container(
              alignment: Alignment.centerLeft,
              decoration: boxDecorationStyle,
              padding: EdgeInsets.only(
                right: 10.0,
                left: 10.0,
                top: 10.0,
                bottom: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'Name: ',
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontFamily: 'Open Sans',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10.0),
                      Text(name,
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontFamily: 'Open Sans',
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal))
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Text(
                        'Email: ',
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontFamily: 'Open Sans',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10.0),
                      Text(email,
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontFamily: 'Open Sans',
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal))
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Text(
                        'Contact Number: ',
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontFamily: 'Open Sans',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10.0),
                      Text(number,
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontFamily: 'Open Sans',
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal))
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      Text(
                        'Gender: ',
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontFamily: 'Open Sans',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10.0),
                      Text(gender,
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontFamily: 'Open Sans',
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal))
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Future<void> userDetails() async {
    var details;
    widget.userProfileViewModel.firebaseDbService.instance
        .collection("users")
        .doc(widget.userProfileViewModel.auth.currentUser!.uid)
        .get()
        .then((document) {
      if (document.exists) {
        setState(() {
          details = document.data();
          name = details['full_name'].toString();
          number = details['phone_number'].toString();
          gender = details['gender'].toString();
          email = details['e-mail id'].toString();
        });
      }
    });
  }

  Widget showEmergencyContacts() {
    return Flexible(
      fit: FlexFit.loose,
      child: StreamBuilder(
          stream: widget.userProfileViewModel.firebaseDbService.instance
              .collection("users")
              .doc(widget.userProfileViewModel.auth.currentUser!.uid)
              .collection("emergencyContacts")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (!streamSnapshot.hasData) return Text("");
            return ListView.builder(
                padding: EdgeInsets.only(right: 15, left: 15),
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (ctx, index) {
                  return Card(
                      shadowColor: Colors.black,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        //mainAxisSize: MainAxisSize.min,
                        decoration: boxDecorationStyle,
                        child: ListTile(
                          title: Text(
                              streamSnapshot.data!.docs[index]
                                  ['emergencyContactName'],
                              style: userlabelStyle),
                          subtitle: Text(
                              streamSnapshot.data!.docs[index]
                                  ['emergencyContactNumber'],
                              style: TextStyle(
                                color: Color(0xFF527DAA),
                                fontFamily: 'OpenSans',
                              )),
                        ),
                      ));
                });
          }),
    );
  }

  Widget buildEmergencyContacts() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Emergency Contacts',
                style: TextStyle(
                    color: Colors.blueGrey,
                    fontFamily: 'Open Sans',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => EmergencyContactScreen()));
                },
                icon: Icon(Icons.edit),
                color: Colors.blueGrey,
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                    right: 10.0,
                    left: 10.0,
                    top: 60.0,
                    bottom: 30.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      buildAppScreenLogo(),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        ' User Profile',
                        style: TextStyle(
                          color: Colors.blue,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 25.0),
                      buildPersonalDetails(),
                      SizedBox(height: 25.0),
                      buildEmergencyContacts(),
                      showEmergencyContacts(),
                      SizedBox(height: 25.0),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
    );
  }
}
