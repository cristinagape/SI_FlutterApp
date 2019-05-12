import 'dart:convert' show utf8, base64;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SharedPreferences sp;

  String _email, _password, _ip, _port;
  static String baseUrl;

  _HomeState() {
    SharedPreferences.getInstance().then((pref) {
      sp = pref;
      getSharedPreferenceData();
    });
  }

  Future<http.Response> openGate() async {
    String url = _HomeState.baseUrl + 'command/open';
    Map<String, String> headers = getHashMap();

    return http.post(url, headers: headers);
  }

  Future<http.Response> closeGate() {
    String url = _HomeState.baseUrl + 'command/close';
    Map<String, String> headers = getHashMap();

    return http.post(url, headers: headers);
  }

  Future<http.Response> pauseGate() {
    String url = _HomeState.baseUrl + 'command/pause';
    Map<String, String> headers = getHashMap();

    return http.post(url, headers: headers);
  }

  Future<http.Response> automaticGate() {
    String url = _HomeState.baseUrl + 'command/auto';
    Map<String, String> headers = getHashMap();

    return http.post(url, headers: headers);
  }

  Map<String, String> getHashMap() {
    String data = _email + ":" + _password;
    data = base64.encode(utf8.encode(data));
    String authorization = "Basic " + data;

    Map<String, String> headers = {
      'Authorization': authorization,
    };

    return headers;
  }

  @override
  Widget build(BuildContext context) {
    Widget buttonDisplay = Container(
        //width: MediaQuery.of(context).size.width,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
          new RaisedButton(
            textColor: Colors.black,
            color: Colors.grey,
            onPressed: openGate,
            child: Stack(
              children: <Widget>[
                Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.lock_open)),
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Open Gate",
                      textAlign: TextAlign.right,
                      textScaleFactor: 2.0,
                    ))
              ],
            ),
          ),
          new RaisedButton(
            textColor: Colors.black,
            color: Colors.grey,
            onPressed: closeGate,
            child: Stack(
              children: <Widget>[
                Align(alignment: Alignment.centerLeft, child: Icon(Icons.lock)),
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Close Gate",
                      textAlign: TextAlign.right,
                      textScaleFactor: 2.0,
                    ))
              ],
            ),
          ),
          new RaisedButton(
            textColor: Colors.black,
            color: Colors.grey,
            onPressed: pauseGate,
            child: Stack(
              children: <Widget>[
                Align(alignment: Alignment.centerLeft, child: Icon(Icons.stop)),
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Stop",
                      textAlign: TextAlign.right,
                      textScaleFactor: 2.0,
                    ))
              ],
            ),
          ),
          new RaisedButton(
            textColor: Colors.black,
            color: Colors.grey,
            onPressed: automaticGate,
            child: Stack(
              children: <Widget>[
                Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.brightness_auto)),
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Automatic Mode",
                      textAlign: TextAlign.right,
                      textScaleFactor: 2.0,
                    ))
              ],
            ),
          ),
        ]));

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Gate'),
        ),
        body: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Please select one of the available options:",
              style: TextStyle(fontSize: 25.0),
            ),
          ),
          buttonDisplay,
        ]));
  }

  void getSharedPreferenceData() {
    _ip = sp.getString('ip');
    _port = sp.getString('port');
    _email = sp.getString('email');
    _password = sp.getString('password');

    baseUrl = 'http://' + _ip + ':' + _port + '/';
  }
}
