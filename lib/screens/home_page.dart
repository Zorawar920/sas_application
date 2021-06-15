import 'package:flutter/material.dart';
import '../firebase_services/auth.dart';

class HomePage extends StatelessWidget {
  final AuthBase auth;
  const HomePage({Key? key, required this.auth}) : super(key: key);
  Future<void> _signOutAnonymously() async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          ElevatedButton(onPressed: _signOutAnonymously, child: Text('Logout'))
        ],
      ),
    );
  }
}
