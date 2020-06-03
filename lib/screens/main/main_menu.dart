import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:psycho_app/custom_widgets/particles/Particles.dart';
import 'package:psycho_app/custom_widgets/wave/config.dart';
import 'dart:math' as math;

import 'package:psycho_app/custom_widgets/wave/wave.dart';
import 'package:psycho_app/screens/game/Game3.dart';
import 'package:psycho_app/screens/game/LevelChooser.dart';
import 'package:psycho_app/screens/register/register.dart';
import 'package:psycho_app/screens/settings/settings.dart';
import 'package:psycho_app/screens/settings/temp.dart';

class MainMenu extends StatefulWidget {

  TabController tabController;
  String name;

  @override
  _MainMenuState createState() => _MainMenuState();

  MainMenu({this.tabController, this.name}) {
  }

}

class _MainMenuState extends State<MainMenu>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  List<Color> buttonsAlpha = List.filled(2, Color(0xffffffff));
  String welcomeText = "";

  Future<bool> loadSettings() async {
    await Settings.read('main').then((value) {
      if (value['fullScreen'])
        SystemChrome.setEnabledSystemUIOverlays([]);
      else
        SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
      if (value['welcomeText'] != null) {
        welcomeText = value['welcomeText'];
      }
    });
    await Settings.read('session').then((value) {
      if (value['name'] != null)
        welcomeText += value['name'];
      else
        welcomeText = null;
    });
    return true;
  }


  @override
  void initState() {
    Settings.setParam('main', 'first_launch', false);
    loadSettings().then((value) => setState((){}));
    super.initState();
    animationController =
        new AnimationController(vsync: this, duration: Duration(seconds: 10));
    final curve = new CurvedAnimation(
        parent: animationController,
        curve: Curves.bounceIn,
        reverseCurve: Curves.easeOut);

    animationController.addListener(() {
      setState(() {});
    });
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });

    animation = Tween<double>(begin: 0, end: 2).animate(curve);

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    var buttonW = min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height)/3;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: OrientationBuilder(builder: (context, orientation) {
        return Container(
          color: Colors.white,
          child: Stack(
            alignment: AlignmentDirectional.center,
            fit: StackFit.expand,
            children: <Widget>[
              getWaves(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: buttonW,
                    height: buttonW,
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.all(16),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Game3(folderName: "tBalloons")),
                        );
                      },
                      onTapDown: (tapDownDetails) {
                        buttonsAlpha[0] = Color(0x33ffffff);
                      },
                      onTapCancel: () {
                        buttonsAlpha[0] = Color(0xffffffff);
                      },
                      onTapUp: (tepUpDetails) {
                        buttonsAlpha[0] = Color(0xffffffff);
                      } ,

                      child: Image(
                        image: AssetImage("assets/balloons.png"),
                        colorBlendMode: BlendMode.dstIn,
                        color: buttonsAlpha[0],
                      ),
                    ),
                  ),
                  Container(
                    width: buttonW,
                    height: buttonW,
                    decoration: BoxDecoration(

                      color: Colors.lightBlueAccent.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.all(16),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Game3(folderName: "TRClown")),
                        );
                      },
                      onTapDown: (tapDownDetails) {
                        buttonsAlpha[1] = Color(0x33ffffff);
                      },
                      onTapCancel: () {
                        buttonsAlpha[1] = Color(0xffffffff);
                      },
                      onTapUp: (tepUpDetails) {
                        buttonsAlpha[1] = Color(0xffffffff);
                      } ,
                      child: Image(
                        image: AssetImage("assets/clown.png"),
                        colorBlendMode: BlendMode.dstIn,
                        color: buttonsAlpha[1],
                      ),
                    ),
                  ),
                ],
              )

            ],
          ),
        );
      }),
      floatingActionButton:
      SizedBox(
        width: 60,
        height: 60,
        child: RaisedButton(
          child: Text("?", style: TextStyle(fontSize: 50, color: Colors.white.withOpacity(0.5)),),
          color: Colors.lightBlueAccent[100],
          shape: CircleBorder(),
          onPressed: () {
            Future.delayed(Duration(milliseconds: 0), () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return instuctions();
                  });
            });
          },
        ),
      ),
    );
  }

  Widget getWaves() {
    return
      WaveWidget(
        backgroundColor: Colors.lightBlueAccent.withOpacity(0.6),
        config: CustomConfig(
          gradients: [
//            [Colors.redAccent, Color(0x88F68484)],
//            [Colors.red, Color(0x77E57373)],
//            [Colors.redAccent, Color(0x88F68484)],
//            [Colors.yellow, Color(0x55FFEB3B)]
            [Colors.white, Colors.white.withOpacity(0)],
            [Colors.green, Colors.green],
            [Colors.green[700].withOpacity(0.15), Colors.green[700].withOpacity(0.1)],
            [Colors.green[900].withOpacity(0.1), Colors.green[900].withOpacity(0.1)],

          ],
          blur: MaskFilter.blur(
            BlurStyle.outer,
            0.0,
          ),
          durations: [30000, 30000, 30000, 30000],
          heightPercentages: [0.0, 0.45, 0.65, 0.85],
        ),
        duration: 100,
        isLoop: true,
        size: Size(
          double.infinity,
          double.infinity,
        ),
        waveAmplitude: 10.0,
      );
  }

  Widget getParticles() {
    return
      Positioned.fill(
          child: Particles(
              quan: 20,
              colors : [
            Colors.redAccent[200],
                Colors.red[600],
                Colors.redAccent[400],
                Colors.red[700]
          ],
            duration: Duration(milliseconds: 8000),
            minSize: 0.4,
            maxSize: 0.8,
          ));
  }

}

instuctions() {
  return  StatefulBuilder(
    builder: (context, setState)
  {
    double fontSize = min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height)/30;
    return AlertDialog(
      backgroundColor: Colors.lightBlueAccent.withOpacity(0.5),
      contentPadding: EdgeInsets.only(top: 8),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "В каждой из игр вам надо определить изменился ли набор цветов по сравнению с предыдущей картинкой. При этом, зеленый и синий цвета игнорируются."
                  ,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "Например здесь набор не изменился",
                  style: TextStyle(
                    color: Colors.white,
                      fontSize: fontSize
                  )
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 3,
                    image: AssetImage('assets/209.JPG'),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 3,
                    image: AssetImage('assets/219.JPG'),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "А здесь изменился",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 3,
                      image: AssetImage('assets/209.JPG'),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 3,
                      image: AssetImage('assets/208.JPG'),

                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: [
                  Text(
                    "Если набор изменился, нажмите на ",
                    style: TextStyle(
                      color: Colors.white,
                        fontSize: fontSize
                    ),
                  ),
                  Container(

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.redAccent[100],
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.redAccent,
                      size: fontSize,
                    ),
                  ),
                  Text(
                    " Если цвета остались те же (не считая зеленый и синий) - на ",
                    style: TextStyle(
                      color: Colors.white,
                        fontSize: fontSize
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.green[300],
                    ),

                    child: Icon(
                      Icons.check,
                      color: Colors.green,
                      size: fontSize,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
    );});
}
