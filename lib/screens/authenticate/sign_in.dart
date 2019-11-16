import 'package:flutter/material.dart';
import 'package:husfelagid/services/auth.dart';
import 'package:husfelagid/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // Text field state
  String email = '';
  String password = '';
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
                    padding: EdgeInsets.only(top: 50),
                    height: 260,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/husfelag_logo.PNG',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        left: 30,
                        right: 30,
                        top: 30,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Netfang",
                                  prefixIcon: Icon(Icons.email),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
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
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  "Gleymt lykilorð?",
                                  style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 15,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            buildButton(),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Ertu ekki með aðgang?",
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
                                    "Stofnaðu aðgang!",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Theme.of(context).accentColor,
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
          );
  }

  Widget buildButton() {
    return GestureDetector(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          setState(() => loading = true);
          dynamic result =
              await _auth.signInWithEmailAndPassword(email, password);
          if (result == null) {
            setState(() {
              error = 'Gat ekki skráð inn á þessum upplýsingum';
              loading = false;
            });
          }
        }
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(23),
          color: Theme.of(context).accentColor,
        ),
        child: Center(
          child: Text(
            "SKRÁ INN",
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
