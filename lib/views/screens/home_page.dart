import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sas_application/uniformity/custom_bottom_nav_bar.dart';
import 'package:sas_application/view_models/home_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:sas_application/enums.dart';
import 'dart:math' as math show sin, pi, sqrt;

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

  void onStop(String s) {}
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late AnimationController _controller;
  bool voice_button_clicked = false;

  String dropDownValue = "";
  List<String> cityList = [
    '1. I may call you',
    '2. Please come to me, I maybe in Danger',
    '3. I need immediate help !'
  ];

  Widget animatedButton() {
    return GestureDetector(
        onTap: () {
          setState(() {
            widget.homeViewModel.stopRecord();
            voice_button_clicked = false;
            _controller.dispose();
          });
        },
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(200),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: <Color>[
                    Colors.blueAccent,
                    Colors.blueAccent
                    //Color.lerp(Colors.blueAccent, Colors.black, .05)
                  ],
                ),
              ),
              child: ScaleTransition(
                  scale: Tween(begin: 0.95, end: 1.0).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: const CurveWave(),
                    ),
                  ),
                  child: Icon(
                    Icons.mic,
                    color: Colors.white,
                    size: 100,
                  )),
            ),
          ),
        ));
  }

  Widget afterButton() {
    return CustomPaint(
      painter: CirclePainter(
        _controller,
        color: Colors.blueAccent,
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        child: animatedButton(),
      ),
    );
  }

  Widget beforeButton(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(30),
            primary: Colors.blueAccent),
        child: Icon(
          Icons.mic,
          color: Colors.white,
          size: 100,
        ),
        onPressed: () {
          setState(() {
            widget.homeViewModel.startRecord(this.context);
            voice_button_clicked = true;
            _controller = AnimationController(
              duration: const Duration(milliseconds: 2000),
              vsync: this,
            )..repeat();
          });
        });
  }

  Widget sosButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.all(30),
          primary: Colors.redAccent),
      child: Text(
        'SOS',
        style: TextStyle(
          color: Colors.white,
          letterSpacing: 1.5,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'OpenSans',
        ),
      ),
      onPressed: () async {
        await widget.homeViewModel.map(dropDownValue);
      },
    );
  }

  @override
  void initState() {
    setFilters();
    super.initState();
  }

  setFilters() {
    setState(() {
      dropDownValue = cityList[0];
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              voice_button_clicked ? afterButton() : beforeButton(this.context),
              SizedBox(
                height: 20,
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[800]),
                    hintText: "Message",
                    fillColor: Colors.blue[200]),
                value: dropDownValue,
                onChanged: (value) {
                  setState(() {
                    dropDownValue = value.toString();
                  });
                },
                items: cityList
                    .map((cityTitle) => DropdownMenuItem(
                        value: cityTitle, child: Text("$cityTitle")))
                    .toList(),
              ),
              SizedBox(
                height: 20,
              ),
              sosButton()
            ],
          )),
          bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
        ),
        onWillPop: () async => false);
  }
}

class CurveWave extends Curve {
  const CurveWave();
  @override
  double transform(double t) {
    if (t == 0 || t == 1) {
      return 0.01;
    }
    return math.sin(t * math.pi);
  }
}

class CirclePainter extends CustomPainter {
  CirclePainter(
    this._animation, {
    required this.color,
  }) : super(repaint: _animation);
  final Color color;
  final Animation<double> _animation;
  void circle(Canvas canvas, Rect rect, double value) {
    final double opacity = (1.0 - (value / 4.0)).clamp(0.0, 1.0);
    final Color _color = color.withOpacity(opacity);
    final double size = rect.width / 2;
    final double area = size * size;
    final double radius = math.sqrt(area * value / 4);
    final Paint paint = Paint()..color = _color;
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    for (int wave = 3; wave >= 0; wave--) {
      circle(canvas, rect, wave + _animation.value);
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => true;
}
