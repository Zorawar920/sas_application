import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String chatId;
  ChatPage({Key? key, required this.chatId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatScreen(
        chatId: chatId,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String chatId;
  ChatScreen({Key? key, required this.chatId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_ChatScreenState');
  final _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String groupChatId = " ";
  @override
  void initState() {
    super.initState();
    generateGroupChatId();
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    return true;
  }

  Widget buildItem(int index, DocumentSnapshot? doc) {
    if (doc != null) {
      if (doc.get('idFrom') == FirebaseAuth.instance.currentUser!.uid) {
        return Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                doc.get('content'),
                style: TextStyle(
                    color: Colors.white, fontSize: 15, fontFamily: 'OpenSans'),
              ),
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 10.0),
              width: 200.0,
              decoration: BoxDecoration(
                  color: Color(0xFF527DAA),
                  borderRadius: BorderRadius.circular(10.0)),
              margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 5.0),
            )
          ],
        );
      } else {
        return Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      doc.get('content'),
                      style: TextStyle(color: Colors.white),
                    ),
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    width: 200.0,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8.0)),
                    margin: EdgeInsets.only(left: 10.0, bottom: 10.0),
                  )
                ],
              )
            ],
          ),
        );
      }
    }
    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Flexible(
              child: groupChatId.isNotEmpty
                  ? StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('messages')
                          .doc(groupChatId)
                          .collection(groupChatId)
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            padding: EdgeInsets.all(10.0),
                            itemBuilder: (context, index) =>
                                buildItem(index, snapshot.data?.docs[index]),
                            itemCount: snapshot.data?.docs.length,
                            reverse: true,
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.black),
                            ),
                          );
                        }
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _controller,
                        focusNode: _focusNode,
                        style: TextStyle(
                          color: Color(0xFF527DAA),
                          fontFamily: 'OpenSans',
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Leave a message',
                          focusColor: Colors.blueGrey,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter your message to continue';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _focusNode.requestFocus();
                          onSendMessage(_controller.text);
                          _controller.clear();
                        }
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.send,
                            color: Colors.blueGrey,
                          ),
                          SizedBox(width: 4),
                          Text('SEND',
                              style: TextStyle(color: Colors.blueGrey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        )
      ],
    ));
  }

  void onSendMessage(String message) {
    var documentReference = FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        {
          'idFrom': FirebaseAuth.instance.currentUser!.uid.toString(),
          'idTo': widget.chatId,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'content': message
        },
      );
    });
  }

  void generateGroupChatId() {
    var id = FirebaseAuth.instance.currentUser!.uid;
    var peerid = widget.chatId;
    if (id.hashCode <= peerid.hashCode) {
      groupChatId = '$id-$peerid';
    } else {
      groupChatId = '$peerid-$id';
    }
  }
}
