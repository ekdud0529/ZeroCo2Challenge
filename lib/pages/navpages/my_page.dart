import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: const EdgeInsets.all(10),
                  child: TextButton(
                    onPressed: () async {
                      await launchUrl(Uri.parse('https://cpoint.or.kr/'));
                    },
                    child: Text("탄소중립 포인트"),
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 30),
                      backgroundColor: const Color(0xfff2a900),
                      primary: Colors.white,
                      padding: EdgeInsets.all(20),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: (){
                    FirebaseAuth.instance.signOut();
                    Fluttertoast.showToast(msg: '로그아웃',
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.grey,
                        fontSize: 20,
                        textColor: Colors.white,
                        toastLength: Toast.LENGTH_SHORT);
                  },
                  child: Text("로그아웃"),
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 30),
                    backgroundColor: const Color(0xfff2a900),
                    primary: Colors.white,
                    padding: EdgeInsets.all(20),
                  ),
                ),
              ]
          )
      )
    );
  }
}