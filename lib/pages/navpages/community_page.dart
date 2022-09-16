import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

List<String> _listKeys = [];
List<String> _listValues = [];

Future<void> getData(ref) async {
  await ref.get().then((snapshot){
    if (snapshot.exists) {
      _listValues.clear();
      _listKeys.clear();
      Map<dynamic, dynamic> values = snapshot.value as Map;
      values.forEach((key, value) {
        _listKeys.add(key.toString());
        _listValues.add(value.toString());
        print(key);
        print(value);
      });
    }
  });
}

class community extends StatelessWidget {
  final ref = FirebaseDatabase.instance.ref('performance');
  @override
  Widget build(BuildContext context) {
    getData(ref);
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 챌린지',
          style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
          ),
        ),
        backgroundColor: const Color(0xfff2a900),
        centerTitle: true,
        toolbarHeight: 80,
      ),
      body: ListView.builder(
        itemCount: _listKeys.length,
        itemBuilder: (context, index){
          return Card(
              child: Row(
                children: [
                  SizedBox(
                      width: 100,
                      height: 100,
                          child: Center(
                            child: Text(_listKeys[index],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: const Color(0xff60584C),
                              ),
                            ),
                          )
                      ),
                      Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Text(
                                  _listValues[index],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey),
                                ),
                              )
                            ],
                          )
                      )
                    ],
                  )
              );
            },
          ),
    );
  }
}
