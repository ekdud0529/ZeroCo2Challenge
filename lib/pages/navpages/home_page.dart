import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'event.dart';
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
  late Map<DateTime, List<Event>> selectedEvents;

  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  DatabaseReference ref = FirebaseDatabase.instance.ref("performance");
  List<Challenge> makeList = [];


  TextEditingController _eventController = TextEditingController(); // 텍스트 필드에서 text 가져오기
  String name = "";

  @override
  void initState() {
    selectedEvents = {};
    super.initState();
  }

  void _fetchEvents() async{
    // sharedpreferences has no option to save the map directly
    // selectedEvents.clear();
    var prefs = await SharedPreferences.getInstance();
    String endcodedMap = json.encode(selectedEvents);
    prefs.setString('challengeDate', endcodedMap);
    String? encodedMap = prefs.getString('challengeData');
    selectedEvents = json.decode(encodedMap!);
  }

  List<Event> _getEventsfromDay(DateTime date) {
    _fetchEvents();
    return selectedEvents[date] ?? [];
  }


  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff2a900),
        title: Text("Challenge"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: selectedDay,
            firstDay: DateTime(1990),
            lastDay: DateTime(2050),
            calendarFormat: format,
            onFormatChanged: (CalendarFormat _format) {
              setState(() {
                format = _format;
              });
            },
            startingDayOfWeek: StartingDayOfWeek.sunday,
            daysOfWeekVisible: true,

            //Day Changed
            onDaySelected: (DateTime selectDay, DateTime focusDay) {
              setState(() {
                selectedDay = selectDay;
                focusedDay = focusDay;
              });
              // print(focusedDay);
            },
            selectedDayPredicate: (DateTime date) {
              return isSameDay(selectedDay, date);
            },

            eventLoader: _getEventsfromDay,


            //To style the Calendar
            calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                color: Color(0xff60584C),
                // color: (255, 188, 80),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10.0),
              ),
              selectedTextStyle: TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(
                color: const Color(0xfff2a900),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10.0),
              ),
              defaultDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10.0),
              ),
              weekendDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: Color(0xff60584C),
                borderRadius: BorderRadius.circular(10.0),
              ),
              formatButtonTextStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          /// 새로추가
          Expanded(
            child:FutureBuilder<List<Challenge>>(
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

                      /// sqlite datetime 저장 불가능 -> 다시 DateTime으로 parsing
                      DateTime sqlDate = DateTime.parse(challenge.date);
                      ///
                      ///

                      // if (selectedEvents[sqlDate] != null) {
                      //   selectedEvents[sqlDate]?.add(
                      //     Event(title: _eventController.text),
                      //   );
                      // } else {
                      //   selectedEvents[sqlDate] = [
                      //     Event(title: _eventController.text)
                      //   ];
                      // }
                      ///
                      // _fetchEvents(); // add to shared preferences
                      return Card(
                          child: Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          width: 200,
                                          height: 50,
                                          child: Center(
                                            child: Text(challenge.challenge,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: const Color(0xff60584C),
                                              ),
                                            ),
                                          )
                                      ),
                                    ],
                                  )
                              ),

                              Container(
                                // width: MediaQuery.of(context).size.width * 0.7,
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    challenge.date,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey),
                                  ),
                                ),

                              )
                            ],
                          )
                      );
                      return Center(
                        child:ListTile(
                          title:Text(challenge.challenge),
                        ),
                      );
                    }).toList(),
                  );
                }),
          ),

          ///
          // ..._getEventsfromDay(selectedDay).map(
          //       (Event event) => ListTile(
          //     title: Text(event.title),
          //   ),
          // ),
          ///
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xfff2a900),

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


                  // 텍스트 필드가 비었을 때
                  if (_eventController.text.isEmpty) {

                  } else { // challenge 입력
                    /// 마커만들 때 쓰일 Map<DateTime, List<Event>> 원소 추가 코드
                    ////////////////////////////////////////////////////////////
                    if (selectedEvents[selectedDay] != null) {
                      selectedEvents[selectedDay]?.add(
                        Event(title: _eventController.text),
                      );
                    } else {
                      selectedEvents[selectedDay] = [
                        Event(title: _eventController.text)
                      ];
                    }
                    // _fetchEvents();
                    ///////////////
                    // 로그인한 사용자정보
                    User? user = FirebaseAuth.instance.currentUser;
                    for(final providerProfile in user!.providerData){
                      final emailAddress = providerProfile.email;
                      List<String>? currentUser = emailAddress?.split('@');
                      name = currentUser![0];
                    }
                    // 현재 날짜
                    final dateStr = DateFormat('yyyy-MM-dd').format(selectedDay);
                    // realtime firebase
                    await ref
                        .child(name)
                        .set(_eventController.text)
                        .asStream();
                    // sqlite
                    await DatabaseHelper.instance.add(
                      Challenge(date:dateStr, challenge: _eventController.text),
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
        label: Text("🌱"),
        icon: Icon(Icons.add),
      ),
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
    /// selectedEvents : Map<Datetime, List<Event>>


    return challengeList;
  }

  Future<int> add(Challenge challenge) async{
    Database db = await instance.database;
    return await db.insert('my_challenge', challenge.toMap());
  }

}