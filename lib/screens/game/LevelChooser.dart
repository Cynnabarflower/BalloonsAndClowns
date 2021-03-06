import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psycho_app/custom_widgets/wave/config.dart';
import 'package:psycho_app/custom_widgets/wave/wave.dart';
import 'package:psycho_app/screens/settings/settings.dart';
import 'Game3.dart';
import 'dart:math';

class LevelChooser extends StatefulWidget {
  var folderName = "assets/tBalloons/";

  @override
  State<StatefulWidget> createState() => _LevelChooserState();
}

class _LevelChooserState extends State<LevelChooser> {
  var levels;
  List<Widget> levelButtons = [];
  var buttonW;
  var wrapSpacing;
  var starSize;
  var orientation;

  Future<bool> loadSettings() async {
    await Settings.read('main').then((value) async {
      var levelsString = await DefaultAssetBundle.of(context)
          .loadString(widget.folderName + 'answers.txt');

      levels = Map<String, dynamic>.from(jsonDecode(levelsString));

      for (var level in levels.keys) {
        for (var stage in levels[level]["level"])
          switch (stage['answer']) {
            case "s":
              stage['answer'] = (ANSWERS.SAME);
              break;
            case "d":
              stage['answer'] = (ANSWERS.DIFFERENT);
              break;
            case "f":
              stage['answer'] = (ANSWERS.NONE);
              break;
            default:
              break;
          }
      }
    });
    return true;
  }

  Widget getLevelButton(String name, int rate, double w, double h) {
    var alpha = 1.0;
    starSize = w/3/1.2;
    return StatefulBuilder(builder: (context, stateSetter) {
      return Container(
        width: w,
        height: h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
//          gradient: LinearGradient(
//            colors: <Color>[
//              Colors.white.withOpacity(0.7).withOpacity(alpha),
//              Colors.grey[200].withOpacity(0.6).withOpacity(alpha),
//            ],
//            begin: Alignment.topCenter,
//            end: Alignment.bottomCenter,
//          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(16),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Game3(stages: levels[name]['level'])),
            );
          },
          onTapDown: (tapDownDetails) {
            alpha = 0.5;
            stateSetter(() {});
          },
          onTapCancel: () {
            alpha = 1.0;
            stateSetter(() {});
          },
          onTapUp: (tepUpDetails) {
            alpha = 1.0;
            stateSetter(() {});
          },
          child: Stack(
            children: <Widget>[
/*              Image(
                image: AssetImage(
                  "assets/cloud.png")
              ),*/
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: h * 0.4,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      rate < 1
                          ? Icon(Icons.star_border,
                              color: Colors.amberAccent, size: starSize)
                          : Icon(Icons.star,
                              color: Colors.amberAccent, size: starSize),
                      rate < 2
                          ? Icon(Icons.star_border,
                              color: Colors.amberAccent, size: starSize)
                          : Icon(Icons.star,
                              color: Colors.amberAccent, size: starSize),
                      rate < 3
                          ? Icon(Icons.star_border,
                              color: Colors.amberAccent, size: starSize)
                          : Icon(Icons.star,
                              color: Colors.amberAccent, size: starSize),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    loadSettings().then((value) => setState(() {wrapSpacing=0;}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (wrapSpacing != null) {
      return OrientationBuilder(builder: (context, or) {
        if (or != orientation) {
          orientation = or;
          levelButtons = [];
          buttonW = min(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height) * 0.75 / 2;
          wrapSpacing = buttonW * 0.25/2;

          for (var level in levels.keys)
            levelButtons.add(getLevelButton(level, 0, buttonW, buttonW));
        }
        return Scaffold(
          resizeToAvoidBottomPadding: false,
          body: SafeArea(
            child: Container(
              color: Colors.white,
              child: Stack(
                alignment: AlignmentDirectional.center,
                fit: StackFit.expand,
                children: <Widget>[
                  getWaves(),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        runSpacing: wrapSpacing,
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: levelButtons,
                        spacing: wrapSpacing,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
    } else {
      return Container(
          alignment: Alignment.center,
          color: Colors.amber,
          child: SizedBox(
            width: 300,
            height: 300,
            child: CircularProgressIndicator(
              strokeWidth: 16,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
            ),
          ));
    }
  }


  Widget getWaves() {
    return
      WaveWidget(
        backgroundColor: Colors.blueAccent[700],
        config: CustomConfig(
          gradients: [
//            [Colors.redAccent, Color(0x88F68484)],
//            [Colors.red, Color(0x77E57373)],
//            [Colors.redAccent, Color(0x88F68484)],
//            [Colors.yellow, Color(0x55FFEB3B)
            [Colors.blueAccent[400].withOpacity(0.5), Colors.blueAccent[400]],
//            [Colors.blueAccent[200].withOpacity(0.5), Colors.blueAccent[200]],
//            [Colors.lightBlueAccent[400].withOpacity(0.5), Colors.lightBlueAccent[400]],
            [Colors.lightBlueAccent[100].withOpacity(0.5), Colors.lightBlueAccent[100]],

          ],
          blur: MaskFilter.blur(
            BlurStyle.outer,
            0.0,
          ),
          durations: [30000, 30000],
          heightPercentages: [0.0,  0.6],
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



}
