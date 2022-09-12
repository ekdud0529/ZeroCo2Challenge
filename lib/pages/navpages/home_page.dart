import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zeroco/pages/navpages/event.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// //
main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(HomePage());
}
// //

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _eventController = TextEditingController();
  DatabaseReference ref = FirebaseDatabase.instance.ref("performance");
  String name="";
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("challenge"),
        ),
        body: Center(
          child: FutureBuilder<List<Challenge>>(
            future: DatabaseHelper.instance.getChallenge(),
            builder: (BuildContext context,
                AsyncSnapshot<List<Challenge>> snapshot){
              if(!snapshot.hasData){
                return Center(child:Text('Loading'));
              }
              return snapshot.data!.isEmpty
                ? Center(child:Text('챌린지에 참여해보세요!'))
                : ListView( // 챌린지 리스트
                  children: snapshot.data!.map((challenge){
                    return Center(
                      child:ListTile(
                        title:Text(challenge.challenge),
                        // title : Column(
                        //   children: [
                        //     const Text(challenge.challenge),
                        //   ],
                        // ),
                      ),
                    );
                  }).toList(),
                );
            }),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Today's Challenge"),
              content: TextFormField(
                controller: _eventController,
              ),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: Text("Ok"),
                  onPressed: () async {
                    print("push btn");
                    // 텍스트 필드가 비었을 때
                    if (_eventController.text.isEmpty) {

                    } else { // challenge 입력
                      // 로그인한 사용자정보
                      User? user = FirebaseAuth.instance.currentUser;
                      for(final providerProfile in user!.providerData){
                        final emailAddress = providerProfile.email;
                        List<String>? currentUser = emailAddress?.split('@');
                        name = currentUser![0];
                      }
                      // 현재 날짜
                      // final dateStr = DateFormat('yyyy-MM-dd').format(selectedDay);
                      await ref
                          .child(name)
                          .set(_eventController.text)
                          .asStream();
                      // sqlite
                      await DatabaseHelper.instance.add(
                        Challenge(date:"2022-09-12", challenge: _eventController.text),
                      );
                    }
                    Navigator.pop(context);
                    _eventController.clear();

                    setState((){});

                    return;
                  },
                ),
              ],
            ),
          ),
          label: Text("Add Challenge"),
          icon: Icon(Icons.add),
        ),
      )
    );
  }
}

class Challenge{
  final int? id;
  final String date;
  final String challenge;

  Challenge({this.id, required this.date, required this.challenge});

  factory Challenge.fromMap(Map<String, dynamic> json) => new Challenge(
      id       : json['id'],
      date     : json['date'],
      challenge: json['challenge']);

  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'date' : date,
      'challenge' : challenge,
    };
  }
}

class DatabaseHelper{
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??=await _initDatabase();

  Future<Database> _initDatabase() async{
    // Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // String path = join(documentsDirectory.path, 'challenges.db');
    String path = join(await getDatabasesPath(), 'my_challenge.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }
  Future _onCreate(Database db, int version) async{
    await db.execute('''
      CREATE TABLE my_challenge(
        id INTEGER PRIMARY_KEY,
        date TEXT,
        challenge TEXT
      )
    ''');
  }

  Future<List<Challenge>> getChallenge() async {
    Database db = await instance.database;
    var challenges = await db.query('my_challenge', orderBy: 'date');
    List<Challenge> challengeList = challenges.isNotEmpty
        ? challenges.map((c)=>Challenge.fromMap(c)).toList()
        :[];
    return challengeList;
  }

  Future<int> add(Challenge challenge) async{
    Database db = await instance.database;
    return await db.insert('my_challenge', challenge.toMap());
  }


}

