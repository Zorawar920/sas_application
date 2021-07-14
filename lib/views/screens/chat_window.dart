import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sas_application/uniformity/CustomBottomNavBar.dart';
import 'package:sas_application/uniformity/style.dart';
import 'package:sas_application/view_models/chat_window_view_model.dart';
import 'package:sas_application/views/screens/chat.dart';
import 'package:stacked/stacked.dart';

import '../../enums.dart';

class ChatWindowScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatWindowViewModel>.reactive(
        builder: (
          context,
          viewModel,
          child,
        ) =>
            MaterialApp(
              debugShowCheckedModeBanner: false,
              home: ChatWindow(chatWindowViewModel: viewModel, addMessage: ""),
            ),
        viewModelBuilder: () => ChatWindowViewModel());
  }
}

// ignore: must_be_immutable
class ChatWindow extends StatefulWidget {
  String addMessage = '';

  final ChatWindowViewModel chatWindowViewModel;
  ChatWindow(
      {Key? key, required this.chatWindowViewModel, required this.addMessage});

  @override
  State<StatefulWidget> createState() => ChatWindowSate();
}

class ChatWindowSate extends State<ChatWindow> {
  final _formKey = GlobalKey<FormState>(debugLabel: 'ChatWindowSate');
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(children: <Widget>[
          Expanded(
            child: FutureBuilder<List>(
                future: _getUsers(),
                builder: (ctx, snapShots) {
                  if (snapShots.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final documents = snapShots.data!;
                  return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (ctx, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (builder) => ChatPage(
                                          chatId: snapShots.data![index]
                                              ['userId'],
                                        )),
                                (Route<dynamic> route) => false);
                          },
                          child: Card(
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
                                      snapShots.data![index]
                                          ['emergencyContactName'],
                                      style: TextStyle(
                                        color: Color(0xFF527DAA),
                                        fontFamily: 'OpenSans',
                                      )),
                                  subtitle: Text(
                                      snapShots.data![index]
                                          ['emergencyContactNumber'],
                                      style: TextStyle(
                                        color: Color(0xFF527DAA),
                                        fontFamily: 'OpenSans',
                                      )),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                }),
          )
        ])),
        bottomNavigationBar:
            CustomBottomNavBar(selectedMenu: MenuState.message));
  }

  Future<List> _getUsers() async {
    List users = [];

    var dataShots = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("emergencyContacts")
        .where("emergencyContactUserId", isNotEqualTo: "")
        .get(GetOptions(source: Source.cache));

    var data = dataShots.docs;
    for (var map in data) {
      users.add({
        "emergencyContactName": map['emergencyContactName'],
        "emergencyContactNumber": map['emergencyContactNumber'],
        "userId": map['emergencyContactUserId']
      });
    }
    var whoAddedMeList = await widget.chatWindowViewModel.getWhoAddedMeList();

    for (var whoAddedMeListDetails in whoAddedMeList) {
      if (!users.contains(whoAddedMeListDetails['userId'])) {
        users.add({
          "emergencyContactName": whoAddedMeListDetails['Name'],
          "emergencyContactNumber": whoAddedMeListDetails['Phone'],
          "userId": whoAddedMeListDetails['userId']
        });
      }
    }

    return users;
  }
}
