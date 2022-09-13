import 'package:flutter/material.dart';
import 'package:zeroco/pages/navpages/search_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'community_page.dart';
import 'home_page.dart';
import 'my_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // 만들 페이지 class로 추가
  List pages = [
    // Home은 default 페이지
    HomePage(),
    community(),
    SearchPage(),
    MyPage()
  ];

  int currentIndex = 0;
  void onTap(int index){
    setState((){
      currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body : pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedFontSize: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xfff2a900),
        onTap : onTap,
        currentIndex: currentIndex,
        selectedItemColor: Color(0xff60584C),
        unselectedItemColor:Colors.white,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        elevation: 0,

        //List of item (페이지 종류)
        items:[
          BottomNavigationBarItem(label:"Home", icon: Icon(Icons.apps)),
          BottomNavigationBarItem(label:"Bar", icon: Icon(Icons.bar_chart_sharp)),
          BottomNavigationBarItem(label:"Search", icon: Icon(Icons.search)),
          BottomNavigationBarItem(label:"My", icon: Icon(Icons.person)),
        ]
      ),
    );
  }
}
