import 'package:flutter/material.dart';
import 'package:sas_application/view_models/chat_window_view_model.dart';
import 'package:stacked/stacked.dart';


class ChatWindowScreen extends StatelessWidget {
  String? contactName;
  String? contactPhoneNumber;
  ChatWindowScreen(this.contactName, this.contactPhoneNumber);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ViewModelBuilder<ChatWindowViewModel>.reactive(
        builder: (
          context,
          viewModel,
          child,
        ) =>
            MaterialApp(
              debugShowCheckedModeBanner: false,
              home: ChatWindow(
                chatWindowViewModel: viewModel,
                name: contactName,
                phoneNumber: contactPhoneNumber,
              ),
            ),
        viewModelBuilder: () => ChatWindowViewModel());
  }
}

class ChatWindow extends StatefulWidget {
  final ChatWindowViewModel chatWindowViewModel;
  String? name;
  String? phoneNumber;
  ChatWindow({required this.chatWindowViewModel, this.name, this.phoneNumber});
  @override
  State<StatefulWidget> createState() => ChatWindowSate();
}

class ChatWindowSate extends State<ChatWindow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(left: 0, right: 0, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Connect",
                          style: TextStyle(
                            color: Color(0xFF527DAA),
                            fontFamily: 'OpenSans',
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                    child: Card(
                  margin: EdgeInsets.only(right: 16, left: 16),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          child: Image.asset('assets/logos/sos.png'),
                          height: 45,
                          width: 45,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                widget.name!,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                widget.phoneNumber!,
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.only(right: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: FloatingActionButton(
                onPressed: () {}, //Code goes here
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 25,
                ),
                backgroundColor: Colors.blue,
                elevation: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
