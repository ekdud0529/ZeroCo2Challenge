import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

List<String> _listKeys = [];
List<String> _listValues = [];

class community extends StatelessWidget {
  final ref = FirebaseDatabase.instance.ref('performance').get().then((snapshot){
    if (snapshot.exists){
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
    else {
      print("Can't get datas.");
      Fluttertoast.showToast(msg: "Can't get datas.",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey,
          fontSize: 20,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
    }
  });
  @override
  Widget build(BuildContext context) {

    print(_listKeys[0]);
    return Scaffold(
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
                                width: MediaQuery.of(context).size.width * 0.7,
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
