import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:sas_application/uniformity/CustomBottomNavBar.dart';
import 'package:sas_application/view_models/home_view_model.dart';
import 'package:sms/sms.dart';
import 'package:stacked/stacked.dart';

import 'package:sas_application/enums.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, viewModel, child) => Scaffold(
        body: Home(
          key: key,
          homeViewModel: viewModel,
        ),
      ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}

class Home extends StatefulWidget {
  final HomeViewModel homeViewModel;

  Home({Key? key, required this.homeViewModel});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                    onPressed: () async {
                      await widget.homeViewModel.map();
                       // Navigator.push(context, MaterialPageRoute(builder: (builder) => SosMap()));
                    }, child: Text(
                  'SOS',
                  style: TextStyle(
                    color: Color(0xFFF7F9FC),
                    letterSpacing: 1.5,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                  ),
                )),
                   TextButton(
                      onPressed: () async{
                         widget.homeViewModel.signOutAnonymously(context);
                       },
                       child: Text("Logout"),
                    ),
              ],
            )
          ),
          bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
        );
  }
}
