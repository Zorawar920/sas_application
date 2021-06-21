import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sas_application/views/screens/home_page.dart';
import 'package:sas_application/views/screens/user_screen.dart';
import '../enums.dart';

class CustomBottomNavBar extends StatelessWidget {
  CustomBottomNavBar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;
  final kPrimaryColor = Color(0xFFFF7643);
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
                icon: Icon(Icons.home_outlined,
                  color: MenuState.home == selectedMenu
                      ? Colors.black
                      : Colors.blueAccent,
                ),
                onPressed: () =>{
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  )
                },
              ),
              IconButton(
                icon: Icon(Icons.chat_bubble),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.person,
                  color: MenuState.profile == selectedMenu
                      ? Colors.black
                      : Colors.blue,
                ),
                onPressed: () =>
                {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => UserScreen()))
                },
              ),
            ],
          )),
    );
  }
}
