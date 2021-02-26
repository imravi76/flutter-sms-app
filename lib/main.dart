import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:flutter_sms/flutter_sms.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  TextEditingController _controllerPeople, _controllerMessage;
  String _message, body;
  List<String> people = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    _controllerPeople = TextEditingController();
    _controllerMessage = TextEditingController();
  }

  void _sendSMS(List<String> recipents) async {
    try {
      String _result = await sendSMS(
          message: _controllerMessage.text, recipients: recipents);
      setState(() => _message = _result);
    } catch (error) {
      setState(() => _message = error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
              "MySMS"
          ),
          backgroundColor: Colors.green,
        ),
        
        body: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Center(
                  child: Text(
                      "SMS App",
                    style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 36),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _controllerPeople,
                  decoration: InputDecoration(
                    labelText: "Enter Phone Number..."
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                          controller: _controllerMessage,
                      decoration: InputDecoration(
                        labelText: "Say Something..."
                      ),
                    ),
                    ),

                    IconButton(
                      onPressed: () => setState((){
                        people.add(_controllerPeople.text.toString());
                        _controllerPeople.clear();
                        _send();
                      }),
                      //color: Colors.white,
                      icon: Icon(
                        Icons.send,
                        color: Colors.blue,
                      ),
                      iconSize: 50,
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

  void _send() {
    if (people == null || people.isEmpty) {
      setState(() => _message = "At Least 1 Person or Message Required");
    } else {
      _sendSMS(people);
    }
  }

}
