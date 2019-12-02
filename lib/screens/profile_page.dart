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
  bool _status = true;
  bool _nameStatus = true;
  bool _emailStatus = true;
  bool _homeStatus = true;
  //final FocusNode myFocusNode = FocusNode();

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String _currentName;
  String _currentEmail;
  String _currentHome;
  String _currentPassword;

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

            return new Scaffold(
                appBar: AppBar(
                  title: Text('Mín síða',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          fontFamily: 'sans-serif-light',
                          color: Colors.white)),
                ),
                body: new Container(
                  color: Colors.white,
                  child: new ListView(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          new Container(
                            height: 50.0,
                            color: Colors.white,
                            child: new Column(
                              children: <Widget>[
                                Padding(
                                    padding:
                                        EdgeInsets.only(left: 20.0, top: 20.0),
                                    child: new Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                    )),
                                /*Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: new Stack(fit: StackFit.loose, children: <Widget>[
                            new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Container(
                                    width: 140.0,
                                    height: 140.0,
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                        image: new ExactAssetImage(
                                            'assets/images/as.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 90.0, right: 100.0),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      radius: 25.0,
                                      child: new Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                )),
                          ]),
                        )*/
                              ],
                            ),
                          ),
                          new Container(
                            color: Color(0xffFFFFFF),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 25.0),
                              child: Form(
                                key: _formKey,
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 25.0, right: 25.0, top: 0.0),
                                        child: new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            new Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                new Text(
                                                  'Mínar upplýsingar ',
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            // new Column(
                                            //   mainAxisAlignment:
                                            //       MainAxisAlignment.end,
                                            //   mainAxisSize: MainAxisSize.min,
                                            //   children: <Widget>[
                                            //     _status
                                            //         ? _getEditIcon()
                                            //         : new Container(),
                                            //   ],
                                            // )
                                          ],
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 25.0, right: 25.0, top: 25.0),
                                        child: new Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            new Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                new Text(
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
                                        child: new Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            new Flexible(
                                              child: new TextFormField(
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
                                            new Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                _nameStatus
                                                    ? _getNameEditIcon()
                                                    : new Container(),
                                              ],
                                            )
                                          ],
                                        )),
                                        if(!_nameStatus) 
                                          Padding(
                                          padding: EdgeInsets.only(
                                              left: 25.0, right: 25.0, top: 45.0),
                                          child: new Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 10.0),
                                                  child: Container(
                                                      child: new RaisedButton(
                                                    child: new Text("Vista"),
                                                    textColor: Colors.white,
                                                    color: Colors.green,
                                                    onPressed: () async {
                                                    if (_formKey.currentState.validate()) {
                                                        await DatabaseService(uid: user.uid).updateUserData(
                                                                _currentName ?? userData.name,
                                                                _currentEmail ?? userData.email,
                                                                _currentHome ?? userData.home,
                                                                userData.resId,
                                                                userData.apartId
                                                            );
                                                      }
                                                      setState(() {
                                                        _nameStatus = true;
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                new FocusNode());
                                                      });
                                                    },
                                                    shape:
                                                        new RoundedRectangleBorder(
                                                            borderRadius:
                                                                new BorderRadius
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
                                                      child: new RaisedButton(
                                                    child: new Text("Hætta við"),
                                                    textColor: Colors.white,
                                                    color: Colors.red,
                                                    onPressed: () {
                                                      setState(() {
                                                        _nameStatus = true;
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                new FocusNode());
                                                      });
                                                    },
                                                    shape:
                                                        new RoundedRectangleBorder(
                                                            borderRadius:
                                                                new BorderRadius
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
                                        child: new Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            new Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                new Text(
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
                                        child: new Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            new Flexible(
                                              child: new TextFormField(
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
                                            new Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                _emailStatus
                                                    ? _getEmailEditIcon()
                                                    : new Container(),
                                              ],
                                            )
                                          ],
                                        )),
                                        if(!_emailStatus) 
                                          Padding(
                                          padding: EdgeInsets.only(
                                              left: 25.0, right: 25.0, top: 45.0),
                                          child: new Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 10.0),
                                                  child: Container(
                                                      child: new RaisedButton(
                                                    child: new Text("Vista"),
                                                    textColor: Colors.white,
                                                    color: Colors.green,
                                                    onPressed: () async {
                                                    if (_formKey.currentState.validate()) {
                                                      if (_currentEmail != userData.email) {
                                                         print('now changing email');
                                                         await _auth.changeEmail(_currentEmail);
                                                         print('now email is changed');
                                                       }
                                                        await DatabaseService(uid: user.uid).updateUserData(
                                                                _currentName ?? userData.name,
                                                                _currentEmail ?? userData.email,
                                                                _currentHome ?? userData.home,
                                                                userData.resId,
                                                                userData.apartId
                                                            );
                                                      }
                                                      setState(() {
                                                        _emailStatus = true;
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                new FocusNode());
                                                      });
                                                    },
                                                    shape:
                                                        new RoundedRectangleBorder(
                                                            borderRadius:
                                                                new BorderRadius
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
                                                      child: new RaisedButton(
                                                    child: new Text("Hætta við"),
                                                    textColor: Colors.white,
                                                    color: Colors.red,
                                                    onPressed: () {
                                                      setState(() {
                                                        _emailStatus = true;
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                new FocusNode());
                                                      });
                                                    },
                                                    shape:
                                                        new RoundedRectangleBorder(
                                                            borderRadius:
                                                                new BorderRadius
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
                                        child: new Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            new Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                new Text(
                                                  'Heimilisfang',
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
                                        child: new Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            new Flexible(
                                              child: new TextFormField(
                                                initialValue: userData.home,
                                                decoration: const InputDecoration(
                                                    hintText:
                                                        "Skráðu heimilisfangið þitt"),
                                                validator: (val) => val.isEmpty
                                                    ? 'Vinsamlegast skráðu heimilisfang'
                                                    : null,
                                                onChanged: (val) => setState(
                                                    () => _currentHome = val),
                                                enabled: !_homeStatus,
                                              ),
                                            ),
                                            new Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                _homeStatus
                                                    ? _getHomeEditIcon()
                                                    : new Container(),
                                              ],
                                            )
                                          ],
                                        )),
                                        if(!_homeStatus) 
                                          Padding(
                                          padding: EdgeInsets.only(
                                              left: 25.0, right: 25.0, top: 45.0),
                                          child: new Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(right: 10.0),
                                                  child: Container(
                                                      child: new RaisedButton(
                                                    child: new Text("Vista"),
                                                    textColor: Colors.white,
                                                    color: Colors.green,
                                                    onPressed: () async {
                                                    if (_formKey.currentState.validate()) {
                                                      if (_currentEmail != userData.email) {
                                                         print('now changing email');
                                                         await _auth.changeEmail(_currentEmail);
                                                         print('now email is changed');
                                                       }
                                                        await DatabaseService(uid: user.uid).updateUserData(
                                                                _currentName ?? userData.name,
                                                                _currentEmail ?? userData.email,
                                                                _currentHome ?? userData.home,
                                                                userData.resId,
                                                                userData.apartId
                                                            );
                                                      }
                                                      setState(() {
                                                        _homeStatus = true;
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                new FocusNode());
                                                      });
                                                    },
                                                    shape:
                                                        new RoundedRectangleBorder(
                                                            borderRadius:
                                                                new BorderRadius
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
                                                      child: new RaisedButton(
                                                    child: new Text("Hætta við"),
                                                    textColor: Colors.white,
                                                    color: Colors.red,
                                                    onPressed: () {
                                                      setState(() {
                                                        _homeStatus = true;
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                new FocusNode());
                                                      });
                                                    },
                                                    shape:
                                                        new RoundedRectangleBorder(
                                                            borderRadius:
                                                                new BorderRadius
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
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        child: new Text(
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
                                        child: new Text(
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
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: new TextFormField(
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
                                      child: new TextFormField(
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
                                    //!_status ? _getActionButtons() : new Container(),
                                    // if (!_status)
                                      // Padding(
                                      //   padding: EdgeInsets.only(
                                      //       left: 25.0, right: 25.0, top: 45.0),
                                      //   child: new Row(
                                      //     mainAxisSize: MainAxisSize.max,
                                      //     mainAxisAlignment:
                                      //         MainAxisAlignment.start,
                                      //     children: <Widget>[
                                      //       Expanded(
                                      //         child: Padding(
                                      //           padding:
                                      //               EdgeInsets.only(right: 10.0),
                                      //           child: Container(
                                      //               child: new RaisedButton(
                                      //             child: new Text("Vista"),
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
                                      //                         new FocusNode());
                                      //               });
                                      //             },
                                      //             shape:
                                      //                 new RoundedRectangleBorder(
                                      //                     borderRadius:
                                      //                         new BorderRadius
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
                                      //               child: new RaisedButton(
                                      //             child: new Text("Hætta við"),
                                      //             textColor: Colors.white,
                                      //             color: Colors.red,
                                      //             onPressed: () {
                                      //               setState(() {
                                      //                 _status = true;
                                      //                 FocusScope.of(context)
                                      //                     .requestFocus(
                                      //                         new FocusNode());
                                      //               });
                                      //             },
                                      //             shape:
                                      //                 new RoundedRectangleBorder(
                                      //                     borderRadius:
                                      //                         new BorderRadius
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
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.blue,
        radius: 14.0,
        child: new Icon(
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
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.blue,
        radius: 14.0,
        child: new Icon(
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
  Widget _getHomeEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.blue,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _homeStatus = false;
        });
      },
    );
  }
}
