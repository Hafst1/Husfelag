import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../services/auth.dart';

class ForgotPassword extends StatefulWidget {
  // final Function toggleView;
  // Register({this.toggleView});


  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _warning = '';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  top: 50,
              ),
              child: Text(
                'Týnt lykilorð',
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
                          hintText: "Netfang",
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (val) =>
                            val.isEmpty ? 'Sláðu inn netfang' : null,
                        onChanged: (val) {
                            setState(() => _email = val);
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      buildButton(),
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Go back!'),
                      ),
                    ],
                  ),
                )
              ),
            )
          ],
        )
      ),
    );
  }

  Widget buildButton() {
    return GestureDetector(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          await _auth.sendPasswordResetEmail(_email);
          print("Password reset email sent");

          _popupDialog(context);
        }
        // return Alert(
        //     context: context,
        //     title: "A password reset link has been sent to $_email",
        //     buttons: [
        //       DialogButton(
        //         child: Text('Loka'),
        //         onPressed: () {
        //           Navigator.pop(context);
        //         }
        //       )
        //     ]
        //   );
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
            "Senda",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }

  void _popupDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('A password reset link has been sent to $_email'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Loka')),
            ],
          );
        });
  }

  // Widget showAlert() {
  //   if (_warning != null) {
  //     return Container(
  //       color: Colors.amberAccent,
  //       width: double.infinity,
  //       padding: EdgeInsets.all(8.0),
  //       child: Row(
  //         children: <Widget>[
  //           Padding(
  //             padding: const EdgeInsets.only(right: 8.0),
  //             child: Icon(Icons.error_outline),
  //           ),
  //           Expanded(
  //             child: AutoSizeText(
  //               _warning,
  //               maxLines: 3,
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.only(left: 8.0),
  //             child: IconButton(
  //               icon: Icon(Icons.close),
  //               onPressed: () {
  //                 setState(() {
  //                   _warning = null;
  //                 });
  //               },
  //             ),
  //           )
  //         ],
  //       ),
  //     );
  //   }
  //   return SizedBox(
  //     height: 0,
  //   );
  // }
}