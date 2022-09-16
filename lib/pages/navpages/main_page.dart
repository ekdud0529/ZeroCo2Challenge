import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'community_page.dart';
import 'guide_page.dart';
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
    GuidePage(),
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
        selectedFontSize: 15,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xfff2a900),
        onTap : onTap,
        currentIndex: currentIndex,
        selectedItemColor: Color(0xff60584C),
        unselectedItemColor:Colors.white,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        elevation: 0,

        //List of item (페이지 종류)
        items:[
          BottomNavigationBarItem(label:"Calendar", icon: Icon(Icons.today), ),
          BottomNavigationBarItem(label:"Community", icon: Icon(Icons.supervisor_account)),
          BottomNavigationBarItem(label:"Guide", icon: Icon(Icons.article)),
          BottomNavigationBarItem(label:"MyPage", icon: Icon(Icons.person)),
        ]
      ),
    );
  }
}
