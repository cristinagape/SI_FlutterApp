import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gate_test/home.dart';

void main() => runApp(new MyApp());

Future<SharedPreferences> sharedPreferences;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if(sharedPreferences == null) {
      sharedPreferences = SharedPreferences.getInstance();
    }

    return new MaterialApp(
      theme: new ThemeData(primarySwatch: Colors.blue),
      home: new LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _email, _password, _ip, _port;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _email = new TextEditingController();
    _port = new TextEditingController();
    _ip = new TextEditingController();
    _password = new TextEditingController();


    sharedPreferences.then((prefs) {

      this.initialPopulate(prefs);
    });
  }

  @override
  Widget build(BuildContext context) {
    RegExp regExpEmail = new RegExp(
      r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.+com",
      multiLine: false,
    );
    RegExp regExpIp = new RegExp(
      r"^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$",
      multiLine: false,
    );
    RegExp regExpPort = new RegExp(
      r"((^[0-9]|[1-8][0-9]|9[0-9]|[1-8][0-9]{2}|9[0-8][0-9]|99[0-9]|[1-8][0-9]{3}|9[0-8][0-9]{2}|99[0-8][0-9]|999[0-9]|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5]$))",
      multiLine: false,
    );
    return new Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.black54,
      ),
      backgroundColor: Colors.black,
      body: Form(
        child: Column(children: <Widget>[
          new Theme(
            data: new ThemeData(
                brightness: Brightness.dark,
                inputDecorationTheme: new InputDecorationTheme(
                    labelStyle: new TextStyle(
                        color: Colors.tealAccent, fontSize: 10.0))),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.all(10.0),
                  child: new Form(
                    key: _formKey,
                    autovalidate: true,
                    child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new TextFormField(
                            validator: (input) {
                              if ((regExpIp.hasMatch(input)) == false) {
                                return "Invalid IP.";
                              }
                            },
                            controller: _ip,
                            decoration: new InputDecoration(
                              hintText: "Enter IP",
                            ),
                            keyboardType: TextInputType.text,
                          ),
                          new TextFormField(
                            validator: (input) {
                              if (input.isEmpty) {
                                // return 'Please insert your port number. ( ex 304)';
                              }
                              if (regExpPort.hasMatch(input) == false) {
                                return "Invalid port number";
                              }
                            },
                            controller: _port,
                            decoration: new InputDecoration(
                              hintText: "Enter Port",
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          new TextFormField(
                            validator: (input) {
                              if ((regExpEmail.hasMatch(input)) == false) {
                                return "Please insert a valid email.";
                              }
                            },
                            controller: _email,
                            decoration: new InputDecoration(
                              hintText: "Enter email",
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          new TextFormField(
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Please insert a password.';
                              }
                              if (input.length < 6) {
                                return 'Password must have at least 6 letters.';
                              }
                            },
                            decoration: new InputDecoration(
                              hintText: "Enter password",
                            ),
                            keyboardType: TextInputType.numberWithOptions(),
                            obscureText: true,
                            controller: _password,
                          ),
                          new Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                          ),
                          new RaisedButton(
                            color: Colors.tealAccent,
                            textColor: Colors.black,
                            // padding:EdgeInsets.all(10.0),
                            onPressed: signIn,
                            splashColor: Colors.teal,
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text('Save Data'),
                                new Icon(Icons.forward)
                              ],
                            ),
                          ),
                        ]),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> signIn() async {
    if (_formKey.currentState.validate()) {
      this.saveToSharedPreferences();

      if (_email.toString().isNotEmpty &&
          _password.toString().isNotEmpty &&
          _port.toString().isNotEmpty &&
          _ip.toString().isNotEmpty) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
    }
  }

  void initialPopulate(SharedPreferences prefs) async {
    setState(() {
      _email.text = prefs?.getString('email');
      _port.text = prefs?.getString('port');
      _ip.text = prefs?.getString('ip');
      _password.text = prefs?.getString('password');
    });

    signIn();
  }

  /// ----------------------------------------------------------
  /// Metoda care imi salveaza email, ip, port si password
  /// ----------------------------------------------------------

  void saveToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', _email.text); //save
    await prefs.setString('port', _port.text);
    await prefs.setString('ip', _ip.text);
    await prefs.setString('password', _password.text);
  }
}
