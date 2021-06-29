
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sas_application/uniformity/CustomBottomNavBar.dart';
import 'package:sas_application/uniformity/style.dart';
import 'package:sas_application/view_models/emergency_contact_view_model.dart';
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
  _EmergencyContactScreenAppState createState() => _EmergencyContactScreenAppState();

  static void getDetails() {}
}

class _EmergencyContactScreenAppState extends State<EmergencyContactScreenApp> {

  final globalFormKey = GlobalKey<FormState>();
  String contactName ="";
  String contactNumber ="";
  String number ="";
  Contact? _contact;

  getDetails()  {
    var contact = widget.emergencyContactViewModel.getContactDetails() ;
    setState(() {
      _contact = contact as Contact?;

      contactName = _contact!.fullName;
      contactNumber = _contact!.phoneNumber.number.toString();
    });
  }
  
  Widget buildAppScreenLogo() {
    return Container(
        child: Image.asset(
          'assets/logos/initial_app_screen_logo_1.png',
          height: 220.0,
          width: 220.0,
        ));
  }


  Widget addContact1Btn() {
    return Container(
      //padding: EdgeInsets.symmetric(vertical: 30.0),
      width: double.infinity,
      child: ElevatedButton.icon(
        icon:Icon(Icons.add_circle),
        label: Text('Select Emergency Contact 1',style:TextStyle(
          color: Colors.white,
          letterSpacing: 1.5,
          fontSize: 13.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'OpenSans',
        ),),
        style: ElevatedButton.styleFrom(
          primary: Colors.blueGrey,
          onPrimary: Colors.white,
          elevation: 10.0,
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: getDetails(),
      ),
    );
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
                      addContact1Btn(),
                      new Text(_contact == null ? 'No contact selected.' :contactName +contactNumber,
                      ),
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

