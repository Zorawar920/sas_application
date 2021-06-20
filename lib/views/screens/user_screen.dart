import 'package:flutter/material.dart';
import 'package:sas_application/view_models/user_screen_view_model.dart';
import 'package:stacked/stacked.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ViewModelBuilder<UserScreenViewModel>.reactive(
        builder: (context, viewModel, child) => Scaffold(
              body: UserScreenApp(),
            ),
        viewModelBuilder: () => UserScreenViewModel());
  }
}

class UserScreenApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UserScreenState();
}

class UserScreenState extends State<UserScreenApp> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        child: Center(
      child: Text("USER SCREEN"),
    ));
  }
}
