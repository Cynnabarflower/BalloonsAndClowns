import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psycho_app/routes.dart';
import 'package:psycho_app/screens/settings/settings.dart';

void main() {
  runApp(App());
  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
}

class App extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _AppState();

}

class _AppState extends State<App> {

  bool firstLaunch;

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

//    if (firstLaunch == null) {
//      return Container(
//        alignment: Alignment.center,
//          color: Colors.amber,
//          child: SizedBox(
//        width: 300,
//        height: 300,
//        child: CircularProgressIndicator(
//          strokeWidth: 16,
//          valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
//        ),
//      )
//      );
//    }
    var route;
    if (false)
      route = '/Language';
    else
      route = '/Menu';
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return MaterialApp(
      title: 'App',
      initialRoute: route,
      routes: routes,
      theme: ThemeData(
//        textTheme: GoogleFonts.comfortaaTextTheme(
//          Theme.of(context).textTheme.copyWith(
//            body1: GoogleFonts.comfortaa(fontWeight: FontWeight.w700),
//            body2:  GoogleFonts.comfortaa(fontWeight: FontWeight.w700),
//            button:  GoogleFonts.comfortaa(fontWeight: FontWeight.w700),
//            caption:  GoogleFonts.comfortaa(fontWeight: FontWeight.w700),
//            display1:  GoogleFonts.comfortaa(fontWeight: FontWeight.w700),
//            display2:  GoogleFonts.comfortaa(fontWeight: FontWeight.w700),
//            display3:  GoogleFonts.comfortaa(fontWeight: FontWeight.w700),
//            display4:  GoogleFonts.comfortaa(fontWeight: FontWeight.w700),
//            subhead:  GoogleFonts.comfortaa(fontWeight: FontWeight.w700),
//            subtitle:  GoogleFonts.comfortaa(fontWeight: FontWeight.w700),
//            title:  GoogleFonts.comfortaa(fontWeight: FontWeight.w700),
//            overline:  GoogleFonts.comfortaa(fontWeight: FontWeight.w700),
//            headline:  GoogleFonts.comfortaa(fontWeight: FontWeight.w700),
//
//          )
//      )
      ),
    );
  }

}

