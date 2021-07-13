import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:sas_application/models/firebase_model.dart';
import 'package:sas_application/views/screens/emergency_contact.dart';
import 'package:sas_application/views/screens/home_page.dart';
import 'package:sas_application/views/screens/log_in.dart';
import 'package:sas_application/views/screens/user_profile.dart';
import '../enums.dart';

class CustomBottomNavBar extends StatelessWidget {
  final FireBaseModel _fireBaseModel = new FireBaseModel();
  CustomBottomNavBar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;
  final kPrimaryColor = Color(0xFF527DAA);
  final kPrimaryLightColor = Color(0xFFFFECDF);

  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/Shop_Icon.svg",
                  color: MenuState.home == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () => {
                  if (MenuState.home != selectedMenu)
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      )
                    }
                },
              ),
              IconButton(
                icon: SvgPicture.asset("assets/icons/Chat bubble Icon.svg",
                    color: MenuState.message == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor),
                onPressed: () {
                  // if (MenuState.message != selectedMenu) {
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => ChatWindowScreen()));
                  // }
                },
              ),
              IconButton(
                  icon: SvgPicture.asset(
                    "assets/icons/Phone.svg",
                    color: MenuState.econtact == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                  onPressed: () => {
                        if (MenuState.econtact != selectedMenu)
                          {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) =>
                                        EmergencyContactScreen()))
                          }
                      }),
              IconButton(
                  icon: SvgPicture.asset(
                    "assets/icons/User Icon.svg",
                    color: MenuState.profile == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                  onPressed: () => {
                        if (MenuState.profile != selectedMenu)
                          {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => UserProfile()))
                          }
                      }),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/Log out.svg",
                  color: kPrimaryColor,
                ),
                onPressed: () => {signOutAnonymously(context)},
              )
            ],
          )),
    );
  }

  Future<void> signOutAnonymously(BuildContext context) async {
    try {
      await _fireBaseModel.auth.signOut();
      showPlatformDialog(
          context: context,
          builder: (context) => FutureProgressDialog(getFuture(),
              message: Text('Signing Out.....')));
      Timer(Duration(seconds: 3), () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (builder) => LoginPage()),
            (Route<dynamic> route) => false);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future getFuture() {
    return Future(() async {
      await Future.delayed(Duration(seconds: 5));
      return 'Hello, Future Progress Dialog!';
    });
  }
}
