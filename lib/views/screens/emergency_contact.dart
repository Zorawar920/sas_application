import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sas_application/uniformity/CustomBottomNavBar.dart';
import 'package:sas_application/uniformity/style.dart';
import 'package:sas_application/view_models/emergency_contact_view_model.dart';
import 'package:sas_application/views/screens/chat_window.dart';
import 'package:stacked/stacked.dart';
import '../../enums.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:contact_picker/contact_picker.dart';

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

class _EmergencyContactScreenAppState extends State<EmergencyContactScreenApp> {
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

  List<Widget> _details(cnt, ctx) {
    List<Widget> listing = [];
    if (contactInformation.isEmpty) {
      listing.add(userDetails(contact: cnt));
    } else {
      for (int i = 0; i < contactInformation.length; i++) {
        listing.add(userDetails(
            contact: cnt,
            name: contactInformation[i]['Name'],
            number: contactInformation[i]['Number'],
            index: i,
            context: ctx));
      }
    }
    return listing;
  }

  Widget userDetails(
      {required Contact contact,
      String? name,
      String? number,
      int? index,
      BuildContext? context}) {
    if (contact == null || contactInformation.isEmpty) {
      return Text("No contact selected.",
          style: TextStyle(
            color: Color(0xFF527DAA),
            fontFamily: 'OpenSans',
          ));
    } else {
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
                title: Text(name!, style: UserlabelStyle),
                subtitle: Text(number!,
                    style: TextStyle(
                      color: Color(0xFF527DAA),
                      fontFamily: 'OpenSans',
                    )),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
                TextButton(
                  onPressed: () => {
                    Navigator.push(
                        context!,
                        MaterialPageRoute(
                            builder: (context) =>
                                ChatWindowScreen(name, number)))
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
                  onPressed: () => {removeContact(index!)},
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
    }
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
        onPressed: contactInformation.length >= 3
            ? () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: Text(
                              "You cannot add more than 3 emergency contacts"),
                          content:
                              Text("Please remove a contact to add another"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context, "OK");
                                },
                                child: Text("OK"))
                          ],
                        ));
              }
            : () async {
                try {
                  await widget.emergencyContactViewModel
                      .getContactDetails(context);
                  setState(() {
                    _contact = widget.emergencyContactViewModel.contact;
                    contactName = _contact!.fullName;
                    contactNumber = _contact!.phoneNumber.number.toString();
                    if (contactInformation.isEmpty) {
                      sameContact = false;
                    } else {
                      for (var map in contactInformation) {
                        if (map["Name"] == contactName &&
                            map["Number"] == contactNumber) {
                          sameContact = true;
                          break;
                        } else {
                          sameContact = false;
                        }
                      }
                    }
                    if (sameContact == true) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title:
                                    Text("This contact is already in the list"),
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
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: Text("A messasge will be sent to " +
                                    contactName),
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
                      contactInformation
                          .add({"Name": contactName, "Number": contactNumber});
                    }
                  });
                } catch (e) {
                  print(e.toString());
                }
              },
      ),
    );
  }

  void ifConnect() {
    setState(() {});
  }

  void removeContact(int index) {
    setState(() {
      contactInformation.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    widget.emergencyContactViewModel.askPermissions(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: globalFormKey,
        child: Scaffold(
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Stack(
              children: <Widget>[
                Container(
                  //height: double.infinity,
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
                        addContact1Btn(context),
                        SizedBox(height: 25.0),
                        ..._details(_contact, context)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.econtact),
    );
  }
}
