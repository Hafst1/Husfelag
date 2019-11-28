import 'package:flutter/material.dart';

import '../../services/auth.dart';
import '../../services/database.dart';
import '../../shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // Text field state
  String email = '';
  String password = '';
  String name = '';
  String home = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      top: 50,
                    ),
                    child: Text(
                      "Búa til aðgang",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'AlegreyaSansSC',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        left: 30,
                        right: 30,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: "Fullt nafn",
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              validator: (val) =>
                                  val.isEmpty ? 'Sláðu inn fullt nafn' : null,
                                onChanged: (val) {
                                  setState(() => name = val);
                                }),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: "Heimilisfang",
                                prefixIcon: Icon(Icons.home),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              validator: (val) =>
                                  val.isEmpty ? 'Sláðu inn heimilisfang' : null,
                                onChanged: (val) {
                                  setState(() => home = val);
                                }),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Netfang",
                                  prefixIcon: Icon(Icons.email),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                validator: (val) =>
                                    val.isEmpty ? 'Sláðu inn netfang' : null,
                                onChanged: (val) {
                                  setState(() => email = val);
                                }),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Lykilorð",
                                  prefixIcon: Icon(Icons.lock),
                                  suffixIcon: Icon(Icons.visibility_off),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                obscureText: true,
                                validator: (val) => val.length < 6
                                    ? 'Lykilorð þarf að innihalda 6+ stafi'
                                    : null,
                                onChanged: (val) {
                                  setState(() => password = val);
                                }),
                            SizedBox(
                              height: 60,
                            ),
                            buildButton(),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Ertu nú þegar með aðgang?",
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    widget.toggleView();
                                  },
                                  child: Text(
                                    "Skráðu þig inn!",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              error,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // resizeToAvoidBottomPadding: false,
          );
  }

  Widget buildButton() {
    return GestureDetector(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          setState(() => loading = true);
          dynamic result =
              await _auth.registerWithEmailAndPassword(email, password)
              .then((currentUser) async {
                await DatabaseService(uid: currentUser.uid).updateUserData(name, email, home, '', '');
              });
          if (this.mounted){
            if (result == null) {
              setState(() {
                error = 'Vinsamlegast fylltu út gilt netfang';
                loading = false;
              });
            }
          }
        }
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(23),
          color: Theme.of(context).primaryColor,
        ),
        child: Center(
          child: Text(
            "STOFNA AÐGANG",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }
}
