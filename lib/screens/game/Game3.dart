import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psycho_app/screens/reward/reward.dart';
import 'package:psycho_app/screens/settings/settings.dart';
import 'dart:math';

import 'AnswerButton.dart';
import 'Statistics.dart';

class Game3 extends StatefulWidget {
  int level = 0;
  var stages;
  String folderName;

  Game3({this.folderName, this.stages, this.level = 0}) {

  }

  @override
  State<StatefulWidget> createState() => _Game3State();
}

enum ANSWERS { SAME, DIFFERENT, NONE }
enum GAMES { MAIN, COLOR, FEEDBACK }

class _Game3State extends State<Game3> with TickerProviderStateMixin {
  bool buttonsEnabled = true;
  int currentImageIndex = 0;
  int currentAnswerIndex = 0;
  double dragDelta = 0;
  final ROTATE_STEP = 3.0 / 255;
  Timer timer;
  List<AssetImage> resetImages = [];
  bool loaded = false;
  int countDown = 3;
  AnimationController controller;
  Animation countDownOpaque;
  _GameLevel _gameLevel;
  final GlobalKey _screen = GlobalKey();
  RenderBox _screenBox;
  final GlobalKey _buttonSame = GlobalKey();
  RenderBox _buttonSameBox;
  final GlobalKey _buttonDifferent = GlobalKey();
  RenderBox _buttonDifferentBox;
  Widget mainWidget;
  DateTime startTime;
  AnimationController differencesController;

  //tutorial
  bool isTutorial = false;
  bool showPrevious = true;
  bool showHand = false;
  bool handAnswers = false;
  bool coloredGame = false;
  Duration handDuration = Duration(milliseconds: 600);
  bool repeatTillRight = false;
  int colorGameLength = 0;
  var colorGameColors = [];
  Statistics statistics = Statistics();
  bool nowPlus = false;
  Offset handOffset = Offset(9999, 9999);
  Animation handTween;
  Size lastSize;
  var countdownStyle;


  Future<bool> loadSettings() async {
    var levelsString = await DefaultAssetBundle.of(context)
        .loadString('assets/'+widget.folderName+'/answers.txt');

    var levels = Map<String, dynamic>.from(jsonDecode(levelsString));

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
    widget.stages = levels["1"]["level"];
  }

  Future<bool> _loadAssets({int level = 0}) async {

    _gameLevel = _GameLevel(widget.stages, this, plus: AssetImage('assets/plus.png'), folderName: widget.folderName);
    _gameLevel.loadImages();
    return true;
  }

  @override
  void initState() {
    countdownStyle = GoogleFonts.comfortaa(color: Colors.blueAccent);
    loadSettings().then((value) => _loadAssets());
    initCountdown();
    super.initState();
  }

  void initCountdown() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    final curve = CurvedAnimation(curve: Curves.decelerate, parent: controller);
    countDownOpaque = Tween<double>(begin: 1, end: 0.6).animate(curve);

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          countDown--;
          controller.repeat();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_gameLevel == null || countDown > 0) {
      controller.forward();
      return Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              FittedBox(
                alignment: Alignment.center,
                fit: BoxFit.contain,
                child: Text(
                  countDown.toString(),
                  style: countdownStyle
                ),
              ),
              AnimatedBuilder(
                animation: controller,
                child: Container(color: Colors.white),
                builder: (BuildContext context, Widget child) {
                  return Opacity(
                    opacity: countDownOpaque.value,
                    child: child,
                  );
                },
              ),
            ],
          ));
    }
    if (countDown == 0) {
      updateTimer(nowPlus: false);
      countDown = -1;
    }

    startTime = new DateTime.now();

    if (!coloredGame) updateBoxes();


    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          color: Colors.white,
          child: Stack(
            key: _screen,
            children: [
              Column(
                children: [
                  Expanded(flex: 80, child: getGameWidget()),
                  Expanded(
                    flex: 20,
                    child: getAnswerWidget()
                  )
                ],
              )
            ],
          ),
        ));
  }

  getGameWidget() {
    if (MediaQuery.of(context).size != lastSize) {
      lastSize = MediaQuery.of(context).size;
//      _gameLevel.updateBalloons();
    }


        return SafeArea(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      setState(() {
                        dragDelta += details.primaryDelta;
                        dragDelta = !_gameLevel.hasAnswer()
                            ? 0
                            : dragDelta > 0
                                ? min(dragDelta, 100)
                                : max(dragDelta, -100);
                        print(dragDelta);
                      });
                    },
                    onHorizontalDragEnd: (details) {
                      setState(() {
                        if (dragDelta < -50) {
                          choiceMade(ANSWERS.DIFFERENT);
                        } else if (dragDelta > 50) {
                          choiceMade(ANSWERS.SAME);
                        }
                        dragDelta = 0;
                      });
                    },
                    child: Container(
                        color: Colors.white,
                        alignment: Alignment.center,
                        child: FittedBox(
                          alignment: Alignment.center,
                          fit: BoxFit.fill,
                          child: Builder(
                            builder: (context) {
                              if (nowPlus)
                                return
                              Image(
                                  image: _gameLevel.plus,
                                  width: MediaQuery.of(context).size.width *
                                      0.7,
                                  height:
                                  MediaQuery.of(context).size.height *
                                      0.7);
                              return _gameLevel.getMainWidget(
                              MediaQuery.of(context).size.width * 0.7,
                              MediaQuery.of(context).size.height * 0.7);
                            },
                          ),
                        ))),
              ),
              Visibility(
                visible: showPrevious && !nowPlus,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(),
                  ),
                ),
              ),
            ],
          ),
        );
  }

  getAnswerWidget() {
    return getAnswerButtons();
  }

  Widget getAnswerButtons() {
    return Row(children: [
      Expanded(
          key: _buttonSame,
          flex: 1,
          child: AnswerButton(
              tapped: () => choiceMade(ANSWERS.SAME),
              enabled: _gameLevel.hasAnswer() && !nowPlus,
              icon: Icons.check,
              backgroundColor: Color(0x88008800),
              shapeColor: Color(0x99009900),
              shape: BoxShape.circle)),
      Expanded(
          key: _buttonDifferent,
          flex: 1,
          child: AnswerButton(
              tapped: () => {choiceMade(ANSWERS.DIFFERENT)},
              enabled: _gameLevel.hasAnswer() && !nowPlus,
              icon: Icons.close,
              backgroundColor: Color(0x88880000),
              shapeColor: Color(0x99990000),
              shape: BoxShape.circle))
    ]);
  }

  choiceMade(choice) {
    if (_gameLevel.hasAnswer()) {
      if (_gameLevel.isCorrectAnswer(choice)) {
        statistics.add(
            DateTime
                .now()
                .difference(startTime)
                .inMicroseconds, true);
      } else {
        if (repeatTillRight) {
          setState(() {
            updateTimer(nowPlus: false);
          });
          return;
        } else {
          statistics.add(
              DateTime
                  .now()
                  .difference(startTime)
                  .inMicroseconds, false);
//        print('wrong');
        }
      }
    }

    if (_gameLevel.next()) {
//      _gameLevel.showDifferences(show: false);
      setState(() {
        dragDelta = 0;
          updateTimer(nowPlus: true);
      });
    } else {
      Settings.saveStats(statistics, DateTime.now().toIso8601String());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Reward(statistics)),
      );
    }
  }

  void updateTimer({nowPlus}) {
    this.nowPlus = nowPlus;
    if (timer != null) timer.cancel();

    if (coloredGame) {
      timer = new Timer(Duration(seconds: 3), () {});
      return;
    }

    if (!nowPlus) {
      print('set timer 3 sec');
      timer = new Timer(Duration(seconds: 3), () {
        var ans = dragDelta < -50
            ? ANSWERS.DIFFERENT
            : (dragDelta > 50)
                ? ANSWERS.SAME
                : showHand && handAnswers ? _gameLevel.getAnswer() : ANSWERS.NONE;
        choiceMade(ans);
      });
    } else {
      print('set timer 1 sec');
      timer = new Timer(Duration(seconds: 1), () {

        setState(() {
          updateTimer(nowPlus: false);
        });
//        choiceMade(null);
      });
    }
  }

  @override
  void dispose() {
    if (timer != null) timer.cancel();
    controller.dispose();
    super.dispose();
  }

  void updateHand() {
    if (_buttonSameBox != null) {
      var off;
      if (nowPlus) {
        handOffset = Offset(
            _screenBox.size.width / 2 - 0.455 * 200, _screenBox.size.height);
      } else
      if (_gameLevel.getAnswer() == ANSWERS.SAME) {
        off = _buttonSameBox.localToGlobal(Offset.zero);
        handOffset = Offset(
            off.dx - 0.455 * 200 + _buttonSameBox.size.width / 2,
            off.dy - 0.1 * 200 + _buttonSameBox.size.height / 2);
      } else if (_gameLevel.getAnswer() == ANSWERS.DIFFERENT) {
        off = _buttonDifferentBox.localToGlobal(Offset.zero);
        handOffset = Offset(
            off.dx - 0.455 * 200 + _buttonDifferentBox.size.width / 2,
            off.dy - 0.1 * 200 + _buttonDifferentBox.size.height / 2);
      } else {
        handOffset = Offset(
            _screenBox.size.width / 2 - 0.455 * 200, _screenBox.size.height);
      }
    } else {
      handOffset = Offset(
          _screenBox.size.width / 2 - 0.455 * 200, _screenBox.size.height);
    }
    setState(() {});
  }

  void updateBoxes() {
    if (_screen.currentContext != null) {
      _screenBox = _screen.currentContext.findRenderObject();
      if (_buttonSame != null && _buttonSame.currentContext != null) {
        _buttonSameBox = _buttonSame.currentContext.findRenderObject();
        _buttonDifferentBox =
            _buttonDifferent.currentContext.findRenderObject();
      }
      updateHand();
    }
  }
}

class _GameLevel {
  List<Image> images = [];
  List<Widget> balloonWidgets = [];
  List<dynamic> stages;
  List<ANSWERS> answers;
  AssetImage plus;
  List<Image> resetImages;
  int current = 0;
  bool levelReturned = true;
  bool coloredGame = false;
  Widget mainWidget;
  Widget colorsWidget;
  Color color;
  _Game3State controller;
  List<Balloon> balloons = [];
  List<Balloon> balloonsThumb = [];
  String folderName;

  List<Color> defaultColors = [
    Colors.blue,
    Colors.green,
    Colors.redAccent,
    Colors.greenAccent,
    Colors.yellowAccent,
    Colors.brown,
    Colors.grey
  ];

  loadImages() {
    for (var i = 201; i <= 216; i++)
      images.add(
        Image(
          image: AssetImage("assets/"+folderName+"/"+ i.toString() + ".jpg"),
          fit: BoxFit.fill,
        )
      );
    resetImages = [];
    resetImages.add(
        Image(
          image: AssetImage("assets/"+folderName+"/blue.jpg"),
          fit: BoxFit.fill,
        )
    );
    resetImages.add(
        Image(
          image: AssetImage("assets/"+folderName+"/green.jpg"),
          fit: BoxFit.fill,
        )
    );
  }

  _GameLevel(this.stages, this.controller, {this.plus, this.folderName}) {
    updateBalloons();

//    balloons = createBalloons(stages[current]);
//    balloonsThumb = createBalloons(stages[current]);
  }

  updateBalloons() {
    if (current > 0)
      balloonsThumb = balloons;
    balloons = createBalloons(stages[current]);
  }

  createBalloons(stage, {w = 0, h = 0}) {
    List<Balloon> balloons = [];
    for (var i = 0; i < stage['colors'].length; i++) {
      balloons.add(Balloon(0, 0,
          defaultColors[stage['colors'][i] % defaultColors.length], controller,
          key: GlobalKey()));
    }
    return balloons;
  }

  createMainWidget(num w, num h, balloons, stage) {
    Random r = Random();
    if (stages[stage]['answer'] == "r")
      return Container (

        child: resetImages[r.nextInt((stage ~/ 4) % 2 + 1)],
      );
    return Container(
      child: images[stage - (stage ~/ 4)]
    );
  }

  getMainWidget(w, h) {
    return createMainWidget(w, h, balloons, current);
  }

  bool next() {
    if (current < stages.length - 1) {

        current++;
        updateBalloons();
        levelReturned = true;

      return true;
    }
    return false;
  }


  getAnswer({i = -1}) {
    if (coloredGame) return ANSWERS.SAME;
    if (!levelReturned) return ANSWERS.NONE;
    if (i >= stages.length || current >= stages.length) return ANSWERS.NONE;
    return stages[i > -1 ? i : current]['answer'];
  }

  getNextAnswer() => getAnswer(i: current + 1);

  hasAnswer() {
    return getAnswer() != ANSWERS.NONE && getAnswer() != "r";
  }

  isCorrectAnswer(answer) {
    return answer == getAnswer() || getAnswer() == ANSWERS.NONE;
  }

  getThumb(w, h) {
    print(balloonsThumb.hashCode);
        print(balloons.hashCode);
    if (current > 0) {
      return createMainWidget(w, h, balloonsThumb, current - 1);
    }
    return Container();
  }

  getDifferent() {
    if (current > 0 && stages[current]['answer'] == ANSWERS.DIFFERENT) {
      var changedBalloons = [];
      for (int i = 0; i < 9; i++) {
        if (stages[current - 1]['colors'][i] != stages[current]['colors'][i]) {
          changedBalloons.add(i);
        }
      }
      return changedBalloons;
    } else
      return [];
  }

  final balloonCoords = [
    [125, 45],
    [200, 66],
    [270, 55],
    [96, 111],
    [186, 170],
    [262, 130],
    [81, 193],
    [170, 254],
    [260, 224]
  ];

  getCoordinates(List indexes) {
    var coords = [];
    for (var index in indexes) {
      coords.add(balloonCoords[index]);
    }
    return coords;
  }
}

class Balloon extends StatefulWidget {
  Color color;
  var template = AssetImage('assets/balloon.png');
  double w, h;
  var scaleFactor = 0.25;
  _Game3State controller;
  GlobalKey key;
  num transformScaleX = 1 + Random().nextDouble()/5 - 0.15;
  num transformScaleY = 1 + Random().nextDouble()/5 - 0.15;
  num dx = Random().nextDouble()/20 - 0.025;
  num dy = Random().nextDouble()/10 - 0.025;
  num alpha = Random().nextDouble()/10 - 0.05;
  num beta = Random().nextDouble()/10 - 0.05;

  Balloon(this.w, this.h, this.color, this.controller, {this.key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _BalloonState();
}

class _BalloonState extends State<Balloon> with TickerProviderStateMixin {
  var showDifferences = false;
  var scaleFactor = 0;
  AnimationController rotationController;
  bool forw = false;
  int counter = 2;

  @override
  void initState() {
    rotationController = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
        lowerBound: -pi / 8,
        upperBound: pi / 8)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {

          setState(() {
            if (counter > 0) {
              if (forw)
                rotationController.forward();
              else
                rotationController.reverse();
              forw = !forw;
              counter--;
            } else {
              rotationController.animateTo(0);
              forw = false;
            }
          });
        }
      });
    rotationController.value = 0;

    super.initState();
  }

  void startAnimation() {
    setState(() {

      counter = 2;
      if (!rotationController.isAnimating) rotationController.forward(from: 0);
    });
  }

  void stopAnimation() {
    setState(() {
      counter = 0;
      if (rotationController.isAnimating) rotationController.stop();
    });
  }

  @override
  void dispose() {
    rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      alignment: Alignment.center,
      turns: Tween(begin: 0.0, end: 0.125).animate(rotationController),
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(widget.color, BlendMode.modulate),
        child: Transform(
          transform: Matrix4.skew(widget.alpha, widget.beta),
          child: Image(
              image: widget.template,
              width: widget.w * (showDifferences ? 1 + scaleFactor : 1) * widget.transformScaleX,
              height: widget.h * (showDifferences ? 1 + scaleFactor : 1) * widget.transformScaleY,
              fit: BoxFit.fill),
        ),
      ),
    );
  }
}
