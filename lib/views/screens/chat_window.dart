import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:sas_application/uniformity/custom_bottom_nav_bar.dart';
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

  Widget buildAppScreenLogo() {
    return Container(
        child: Image.asset(
      'assets/logos/initial_app_screen_logo_1.png',
      height: 220.0,
      width: 220.0,
    ));
  }

  Widget headLineConnect() {
    return Text(
      'Connect',
      style: TextStyle(
        color: Colors.blue,
        fontFamily: 'OpenSans',
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget detailAboutDots() {
    return Container(
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.all(Radius.circular(50))),
            ),
            SizedBox(
              width: 5,
            ),
            Text("User is not on our Application")
          ]),
          SizedBox(
            height: 5,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(50))),
            ),
            SizedBox(
              width: 5,
            ),
            Text("User is available on our Application")
          ]),
          SizedBox(
            height: 5,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.all(Radius.circular(50))),
            ),
            SizedBox(
              width: 5,
            ),
            Text("User added you as an Emergency Contact")
          ])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                right: 40.0, left: 40.0, top: 60.0, bottom: 1.0),
            child: buildAppScreenLogo(),
          ),
          SizedBox(
            height: 10,
          ),
          headLineConnect(),
          SizedBox(
            height: 5,
          ),
          detailAboutDots(),
          SizedBox(
            height: 20,
          ),
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
                      shrinkWrap: true,
                      padding: EdgeInsets.only(right: 15, left: 15),
                      itemCount: documents.length,
                      itemBuilder: (ctx, index) {
                        return GestureDetector(
                          onTap: () {
                            if (snapShots.data![index]['userId'] == "") {
                              showPlatformDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text(
                                            "This User is not on our Application"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context, "OK");
                                              },
                                              child: Text("OK"))
                                        ],
                                      ));
                            } else {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (builder) => ChatPage(
                                            chatId: snapShots.data![index]
                                                ['userId'],
                                          )),
                                  (Route<dynamic> route) => false);
                            }
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
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                          color: snapShots.data![index]
                                              ['color'],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50))),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                          color: snapShots.data![index]
                                              ['color2'],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50))),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                          color: snapShots.data![index]
                                              ['color3'],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50))),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
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
        .get(GetOptions(source: Source.cache));

    var data = dataShots.docs;
    for (var map in data) {
      users.add({
        "emergencyContactName": map['emergencyContactName'],
        "emergencyContactNumber": map['emergencyContactNumber'],
        "userId": map['emergencyContactUserId'],
        "color": map['emergencyContactUserId'] == ""
            ? Colors.redAccent
            : Colors.grey,
        "color2":
            map['emergencyContactUserId'] == "" ? Colors.grey : Colors.green,
        "color3": Colors.grey
      });
    }
    var whoAddedMeList = await widget.chatWindowViewModel.getWhoAddedMeList();

    for (var whoAddedMeListDetails in whoAddedMeList) {
      int counter = 0;
      for (var user in users) {
        counter += 1;
        if (user['userId'] != whoAddedMeListDetails['userId'] &&
            users.length == counter) {
          users.add({
            "emergencyContactName": whoAddedMeListDetails['Name'],
            "emergencyContactNumber": whoAddedMeListDetails['Phone'],
            "userId": whoAddedMeListDetails['userId'],
            "color": Colors.grey,
            "color2": Colors.grey,
            "color3": Colors.orangeAccent
          });
        } else if (user['userId'] == whoAddedMeListDetails['userId']) {
          print("dsfsdfsdfdsfdsfsdfdsfjh");
          users[counter - 1]["color3"] = Colors.orangeAccent;
        }
      }
    }

    return users;
  }
}
