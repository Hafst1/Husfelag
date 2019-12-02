import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:husfelagid/services/auth.dart';
import '../models/user.dart';
import '../services/database.dart';
import '../shared/loading.dart';

class ProfilePage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _nameStatus = true;
  bool _emailStatus = true;
  //final FocusNode myFocusNode = FocusNode();

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String _currentName;
  String _currentEmail;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;

            return Scaffold(
                appBar: AppBar(
                  title: Text('Mín síða',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          fontFamily: 'sans-serif-light',
                          color: Colors.white)),
                ),
                body: Container(
                  color: Colors.white,
                  child: ListView(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            height: 50.0,
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 20.0, top: 20.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                    )),
                              ],
                            ),
                          ),
                          Container(
                            color: Color(0xffFFFFFF),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 25.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 25.0, right: 25.0, top: 0.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                  'Mínar upplýsingar ',
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 25.0, right: 25.0, top: 25.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                  'Nafn',
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 25.0, right: 25.0, top: 2.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Flexible(
                                              child: TextFormField(
                                                initialValue: userData.name,
                                                decoration: const InputDecoration(
                                                  hintText: "Skráðu nafnið þitt",
                                                ),
                                                validator: (val) => val.isEmpty
                                                    ? 'Vinsamlegast skráðu nafn'
                                                    : null,
                                                onChanged: (val) => setState(
                                                    () => _currentName = val),
                                                enabled: !_nameStatus,
                                                autofocus: !_nameStatus,
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                _nameStatus
                                                    ? _getNameEditIcon()
                                                    : Container(),
                                              ],
                                            )
                                          ],
                                        )),
                                        if(!_nameStatus) 
                                          Padding(
                                          padding: EdgeInsets.only(
                                              left: 25.0, right: 25.0, top: 45.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 10.0),
                                                  child: Container(
                                                      child: RaisedButton(
                                                    child: Text("Vista"),
                                                    textColor: Colors.white,
                                                    color: Colors.green,
                                                    onPressed: () async {
                                                    if (_formKey.currentState.validate()) {
                                                        await DatabaseService(uid: user.uid).updateUserName(
                                                                _currentName ?? userData.name,
                                                            );
                                                      }
                                                      setState(() {
                                                        _nameStatus = true;
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                FocusNode());
                                                      });
                                                    },
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                        .circular(
                                                                    20.0)),
                                                  )),
                                                ),
                                                flex: 2,
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 10.0),
                                                  child: Container(
                                                      child: RaisedButton(
                                                    child: Text("Hætta við"),
                                                    textColor: Colors.white,
                                                    color: Colors.red,
                                                    onPressed: () {
                                                      setState(() {
                                                        _nameStatus = true;
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                FocusNode());
                                                      });
                                                    },
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                        .circular(
                                                                    20.0)),
                                                  )),
                                                ),
                                                flex: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 25.0, right: 25.0, top: 25.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                  'Netfang',
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 25.0, right: 25.0, top: 2.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Flexible(
                                              child: TextFormField(
                                                initialValue: userData.email,
                                                decoration: const InputDecoration(
                                                    hintText:
                                                        "Skráðu netfangið þitt"),
                                                validator: (val) =>
                                                  val.isEmpty ? 'Sláðu inn netfang' 
                                                  : null,
                                                onChanged: (val) => setState(
                                                    () => _currentEmail = val),
                                                enabled: !_emailStatus,
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                _emailStatus
                                                    ? _getEmailEditIcon()
                                                    : Container(),
                                              ],
                                            )
                                          ],
                                        )),
                                        if(!_emailStatus) 
                                          Padding(
                                          padding: EdgeInsets.only(
                                              left: 25.0, right: 25.0, top: 45.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 10.0),
                                                  child: Container(
                                                      child: RaisedButton(
                                                    child: Text("Vista"),
                                                    textColor: Colors.white,
                                                    color: Colors.green,
                                                    onPressed: () async {
                                                    if (_formKey.currentState.validate()) {
                                                      if (_currentEmail != userData.email) {
                                                         print('now changing email');
                                                         await _auth.changeEmail(_currentEmail);
                                                         print('now email is changed');
                                                       }
                                                        await DatabaseService(uid: user.uid).updateUserEmail(
                                                                _currentEmail ?? userData.email,
                                                            );
                                                      }
                                                      setState(() {
                                                        _emailStatus = true;
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                FocusNode());
                                                      });
                                                    },
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                        .circular(
                                                                    20.0)),
                                                  )),
                                                ),
                                                flex: 2,
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 10.0),
                                                  child: Container(
                                                      child: RaisedButton(
                                                    child: Text("Hætta við"),
                                                    textColor: Colors.white,
                                                    color: Colors.red,
                                                    onPressed: () {
                                                      setState(() {
                                                        _emailStatus = true;
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                FocusNode());
                                                      });
                                                    },
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                        .circular(
                                                                    20.0)),
                                                  )),
                                                ),
                                                flex: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                    /*Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          'Breyta um lykilorð',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      flex: 2,
                                    ),
                                    /*Expanded(
                                      child: Container(
                                        child: Text(
                                          'Nýja lykilorðið',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      flex: 2,
                                    ),*/
                                  ],
                                )),*/
                                    /*Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                              hintText: "Gamla lykilorðið"),
                                          obscureText: true,
                                          validator: (val) => val != userData.password
                                            ? 'Ekki rétt lykilorð'
                                            : null,
                                          enabled: !_status,
                                        ),
                                      ),
                                      flex: 2,
                                    ),
                                    Flexible(
                                      child: TextFormField(
                                        decoration: const InputDecoration(
                                            hintText: "Nýja lykilorðið"),
                                        obscureText: true,
                                        validator: (val) => val.length < 6
                                          ? 'Lykilorð þarf að innihalda 6+ stafi'
                                          : null,
                                        onChanged: (val) => setState(
                                                    () => _currentPassword = val),
                                        enabled: !_status,
                                      ),
                                      flex: 2,
                                    ),
                                  ],
                                )),*/
                                    //!_status ? _getActionButtons() : Container(),
                                    // if (!_status)
                                      // Padding(
                                      //   padding: EdgeInsets.only(
                                      //       left: 25.0, right: 25.0, top: 45.0),
                                      //   child: Row(
                                      //     mainAxisSize: MainAxisSize.max,
                                      //     mainAxisAlignment:
                                      //         MainAxisAlignment.start,
                                      //     children: <Widget>[
                                      //       Expanded(
                                      //         child: Padding(
                                      //           padding:
                                      //               EdgeInsets.only(right: 10.0),
                                      //           child: Container(
                                      //               child: RaisedButton(
                                      //             child: Text("Vista"),
                                      //             textColor: Colors.white,
                                      //             color: Colors.green,
                                      //             onPressed: () async {
                                      //              if (_formKey.currentState.validate()) {
                                      //                 if (_currentEmail != userData.email) {
                                      //                   print('now changing email');
                                      //                   await _auth.changeEmail(_currentEmail);
                                      //                   print('now email is changed');
                                      //                 }
                                      //                 if (_currentPassword != userData.password){
                                      //                   print('now inside password, not supposed to be here');
                                      //                   await _auth.changePassword(_currentPassword);
                                      //                 }
                                      //                 await DatabaseService(uid: user.uid).updateUserData(
                                      //                         _currentName ?? userData.name,
                                      //                         _currentEmail ?? userData.email,
                                      //                         _currentHome ?? userData.home,
                                      //                         userData.resId,
                                      //                         userData.apartId
                                      //                     );
                                      //               }
                                      //               setState(() {
                                      //                 _status = true;
                                      //                 FocusScope.of(context)
                                      //                     .requestFocus(
                                      //                         FocusNode());
                                      //               });
                                      //             },
                                      //             shape:
                                      //                 RoundedRectangleBorder(
                                      //                     borderRadius:
                                      //                         BorderRadius
                                      //                                 .circular(
                                      //                             20.0)),
                                      //           )),
                                      //         ),
                                      //         flex: 2,
                                      //       ),
                                      //       Expanded(
                                      //         child: Padding(
                                      //           padding:
                                      //               EdgeInsets.only(left: 10.0),
                                      //           child: Container(
                                      //               child: RaisedButton(
                                      //             child: Text("Hætta við"),
                                      //             textColor: Colors.white,
                                      //             color: Colors.red,
                                      //             onPressed: () {
                                      //               setState(() {
                                      //                 _status = true;
                                      //                 FocusScope.of(context)
                                      //                     .requestFocus(
                                      //                         FocusNode());
                                      //               });
                                      //             },
                                      //             shape:
                                      //                 RoundedRectangleBorder(
                                      //                     borderRadius:
                                      //                         BorderRadius
                                      //                                 .circular(
                                      //                             20.0)),
                                      //           )),
                                      //         ),
                                      //         flex: 2,
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ));
          } else {
            return Loading();
          }
        });
  }

  Widget _getNameEditIcon() {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: Colors.blue,
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _nameStatus = false;
        });
      },
    );
  }
  Widget _getEmailEditIcon() {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: Colors.blue,
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _emailStatus = false;
        });
      },
    );
  }
}
