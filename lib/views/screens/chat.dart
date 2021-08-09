import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sas_application/views/screens/chat_window.dart';

class ChatPage extends StatelessWidget {
  final String chatId;
  final String name;
  ChatPage({Key? key, required this.chatId, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatScreen(chatId: chatId, name: name),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String name;
  ChatScreen({Key? key, required this.chatId, required this.name})
      : super(key: key);

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
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    return true;
  }

  Widget showChat(int index, DocumentSnapshot? doc) {
    if (doc != null) {
      if (doc.get('idFrom') == FirebaseAuth.instance.currentUser!.uid) {
        return Column(children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Color(0xFF527DAA),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Text(
                doc.get('content'),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          )
        ]);
      } else {
        return Column(children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Text(
                doc.get('content'),
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
          )
        ]);
      }
    }
    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            tooltip: "Return to Chat Window Screen",
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChatWindowScreen()));
            },
          ),
          brightness: Brightness.dark,
          backgroundColor: Color(0xFF527DAA),
          centerTitle: true,
          title: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: widget.name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: 'OpenSans'))),
        ),
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
                                    showChat(index, snapshot.data?.docs[index]),
                                itemCount: snapshot.data?.docs.length,
                                reverse: true,
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black),
                                ),
                              );
                            }
                          },
                        )
                      : Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
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
                            decoration: InputDecoration.collapsed(
                              hintText: 'Leave a message..',
                            ),
                            textCapitalization: TextCapitalization.sentences,
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
        .doc(DateTime.now().microsecondsSinceEpoch.toString());

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        {
          'idFrom': FirebaseAuth.instance.currentUser!.uid.toString(),
          'idTo': widget.chatId,
          'timestamp': DateTime.now().microsecondsSinceEpoch.toString(),
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
