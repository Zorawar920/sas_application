import 'dart:async';

import 'package:flutter/material.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:sas_application/view_models/home_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:sas_application/views/screens/user_screen.dart';
import 'package:sas_application/view_models/user_screen_view_model.dart';

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
    // TODO: implement build
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Home Page'),
            automaticallyImplyLeading: false,
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () async {
                    widget.homeViewModel.signOutAnonymously(context);
                  },
                  child: Text('Logout'))
            ],
          ),
          body: Center(
            child: ElevatedButton(
              onPressed: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => UserScreen()))
              },
              child: Text("User Profile"),
            ),
          ),
        ),
        onWillPop: () async => false);
  }
}