import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zeroco2/main.dart';

class Splash extends StatefulWidget{
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState(){
    Timer(
        Duration(milliseconds: 1500), () {
          Navigator.push(context, MaterialPageRoute(
          builder: (context) => accountPage()
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xfff2a900),
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child:new Center(
          child: SizedBox(
            height: 100,
            width: 100,
              child: Image.asset("assets/icon.png"),
          ),
        ),
      )
    );
  }
}