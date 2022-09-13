import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zeroco/pages/navpages/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';



void main() async{
  // 플러터에서 firebase 사용을 위해선 메인메소드 내에서 비동기 방식으로 반드시
  // 아래 메서드 호출한 후 firebase.initial~을 불러와야함
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: accountPage(),
    );
  }
}

class accountPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: const Color(0xfff2a900), // Color for Android
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      body: Authentication(),
    );
  }
}

class Authentication extends StatelessWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot){
        if (!snapshot.hasData){
          return SignInScreen(
            providerConfigs: [
              EmailProviderConfiguration()
            ],
          );
        }
        return
          MainPage();
      },
    );
  }
}
