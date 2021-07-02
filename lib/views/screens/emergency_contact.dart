import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:sas_application/uniformity/CustomBottomNavBar.dart';
import 'package:sas_application/uniformity/style.dart';
import 'package:sas_application/view_models/emergency_contact_view_model.dart';
import 'package:stacked/stacked.dart';
import '../../enums.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:contact_picker/contact_picker.dart';

import 'chat_window.dart';

class EmergencyContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ViewModelBuilder<EmergencyContactViewModel>.reactive(
        builder: (context, viewModel, child) => MaterialApp(
              debugShowCheckedModeBanner: false,
              home: EmergencyContactScreenApp(
                emergencyContactViewModel: viewModel,
              ),
            ),
        viewModelBuilder: () => EmergencyContactViewModel());
  }
}

class EmergencyContactScreenApp extends StatefulWidget {
  final EmergencyContactViewModel emergencyContactViewModel;

  EmergencyContactScreenApp({required this.emergencyContactViewModel});

  @override
  _EmergencyContactScreenAppState createState() =>
      _EmergencyContactScreenAppState();
}

class _EmergencyContactScreenAppState extends State<EmergencyContactScreenApp>
    with AutomaticKeepAliveClientMixin {
  late bool sameContact;
  final globalFormKey = GlobalKey<FormState>();
  String contactName = "";
  String contactNumber = "";
  Contact? _contact;
  List contactInformation = [];

  Widget buildAppScreenLogo() {
    return Container(
        child: Image.asset(
      'assets/logos/initial_app_screen_logo_1.png',
      height: 220.0,
      width: 220.0,
    ));
  }

  Widget addContact1Btn(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(Icons.add_circle),
        label: Text(
          'Add Emergency Contact',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
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
          try {
            contactInformation =
                await widget.emergencyContactViewModel.getList();
            if (contactInformation.length >= 3) {
              showPlatformDialog(
                  context: context,
                  builder: (BuildContext context) => BasicDialogAlert(
                        title: Text(
                            "You cannot add more than 3 emergency contacts"),
                        content: Text("Please remove a contact to add another"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context, "OK");
                              },
                              child: Text("OK"))
                        ],
                      ));
            } else {
              await widget.emergencyContactViewModel.getContactDetails(context);
              setState(() {
                _contact = widget.emergencyContactViewModel.contact;
                contactName = _contact!.fullName;
                contactNumber = _contact!.phoneNumber.number.toString();
                if (contactInformation.isEmpty) {
                  sameContact = false;
                } else {
                  for (var map in contactInformation) {
                    if (map["emergency-contact-name"] == contactName &&
                        map["emergency-contact-number"] == contactNumber) {
                      sameContact = true;
                      break;
                    } else {
                      sameContact = false;
                    }
                  }
                }
                if (sameContact == true) {
                  showPlatformDialog(
                      context: context,
                      builder: (BuildContext context) => BasicDialogAlert(
                            title: Text("This contact is already in the list"),
                            content: Text("Please choose another contact"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, "OK");
                                  },
                                  child: Text("OK"))
                            ],
                          ));
                } else {
                  showPlatformDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: Text(
                                "A message will be sent to " + contactName),
                            content: Text("Do you accept"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    widget.emergencyContactViewModel
                                        .onEmergencyContactAddtion(
                                            contactNumber);
                                    Navigator.pop(context, "Yes");
                                  },
                                  child: Text("Yes")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, "No");
                                  },
                                  child: Text('No'))
                            ],
                          ));
                  widget.emergencyContactViewModel
                      .addContactInformation(contactName, contactNumber);
                }
              });
            }
          } catch (e) {
            print(e.toString());
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    widget.emergencyContactViewModel.askPermissions(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Form(
        key: globalFormKey,
        child: Scaffold(
          body: Center(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      right: 40.0, left: 40.0, top: 60.0, bottom: 1.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      buildAppScreenLogo(),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Add Emergency Contacts',
                        style: TextStyle(
                          color: Colors.blue,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 25.0),
                      addContact1Btn(context)
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                      stream: widget
                          .emergencyContactViewModel.firebaseDbService.instance
                          .collection("users")
                          .doc(widget
                              .emergencyContactViewModel.auth.currentUser!.uid)
                          .collection("emergency-contacts")
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (!streamSnapshot.hasData) return Text("");
                        return ListView.builder(
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
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        title: Text(
                                            streamSnapshot.data!.docs[index]
                                                ['emergency-contact-name'],
                                            style: UserlabelStyle),
                                        subtitle: Text(
                                            streamSnapshot.data!.docs[index]
                                                ['emergency-contact-number'],
                                            style: TextStyle(
                                              color: Color(0xFF527DAA),
                                              fontFamily: 'OpenSans',
                                            )),
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            TextButton(
                                              onPressed: () => {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ChatWindowScreen(
                                                                streamSnapshot
                                                                    .data!
                                                                    .docs[index]
                                                                        [
                                                                        'emergency-contact-name']
                                                                    .toString(),
                                                                streamSnapshot
                                                                    .data!
                                                                    .docs[index]
                                                                        [
                                                                        'emergency-contact-number']
                                                                    .toString())))
                                              },
                                              child: Text(
                                                'Connect',
                                                style: TextStyle(
                                                  color: Color(0xFF527DAA),
                                                  letterSpacing: 1.5,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'OpenSans',
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            TextButton(
                                              onPressed: () async => {
                                                widget.emergencyContactViewModel
                                                    .deleteData(streamSnapshot
                                                        .data!.docs[index].id)
                                              },
                                              child: Text(
                                                'Remove',
                                                style: TextStyle(
                                                  color: Color(0xFF527DAA),
                                                  letterSpacing: 1.5,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'OpenSans',
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                          ])
                                    ],
                                  ));
                            });
                      }),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.econtact),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
