import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth.dart';
import '../models/user.dart';
import '../services/database.dart';
import '../shared/loading_spinner.dart';

class ProfilePage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage> {
  bool _nameStatus = true;
  bool _emailStatus = true;
  bool _passwordStatus = true;

  final FocusNode myFocusNode = FocusNode();

  final AuthService _auth = AuthService();
  final _nameKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();

  String _currentName;
  String _currentEmail;
  String _currentPassword;

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
                    style: TextStyle(fontSize: 20.0, color: Colors.white)),
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
                        ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 0.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Mínar upplýsingar',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Form(
                                  key: _nameKey,
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 25.0,
                                              right: 25.0,
                                              top: 25.0),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                'Nafn',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 25.0,
                                              right: 25.0,
                                              top: 2.0),
                                          child: Row(
                                            children: <Widget>[
                                              Flexible(
                                                child: TextFormField(
                                                  initialValue: userData.name,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Skráðu nafnið þitt',
                                                  ),
                                                  validator: (val) => val
                                                          .isEmpty
                                                      ? 'Vinsamlegast skráðu nafn'
                                                      : null,
                                                  onChanged: (val) => setState(
                                                      () => _currentName = val),
                                                  enabled: !_nameStatus,
                                                  autofocus: !_nameStatus,
                                                ),
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  _nameStatus
                                                      ? _getNameEditIcon()
                                                      : Container(),
                                                ],
                                              )
                                            ],
                                          )),
                                      if (!_nameStatus)
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 25.0,
                                              right: 25.0,
                                              top: 20.0),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 10.0),
                                                  child: Container(
                                                      child: RaisedButton(
                                                    child: Text('Vista'),
                                                    textColor: Colors.white,
                                                    color: Colors.green,
                                                    onPressed: () async {
                                                      if (_nameKey.currentState
                                                          .validate()) {
                                                        await DatabaseService(
                                                                uid: user.uid)
                                                            .updateUserData(
                                                          _currentName ??
                                                              userData.name,
                                                          userData.email,
                                                          userData
                                                              .residentAssociationId,
                                                          userData.apartmentId,
                                                          userData.isAdmin,
                                                        );
                                                        setState(() {
                                                          _nameStatus = true;
                                                          FocusScope.of(context)
                                                              .requestFocus(
                                                                  FocusNode());
                                                        });
                                                      }
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
                                                  padding: EdgeInsets.only(
                                                      left: 10.0),
                                                  child: Container(
                                                    child: RaisedButton(
                                                      child: Text('Hætta við'),
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
                                                    ),
                                                  ),
                                                ),
                                                flex: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                child: Form(
                                  key: _emailKey,
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 25.0, right: 25.0, top: 25.0),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              'Netfang',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 25.0, right: 25.0, top: 2.0),
                                        child: Row(
                                          children: <Widget>[
                                            Flexible(
                                              child: TextFormField(
                                                initialValue: userData.email,
                                                decoration: InputDecoration(
                                                    hintText:
                                                        'Skráðu netfangið þitt'),
                                                validator: (val) => val.isEmpty
                                                    ? 'Sláðu inn netfang'
                                                    : null,
                                                onChanged: (val) => setState(
                                                    () => _currentEmail = val),
                                                enabled: !_emailStatus,
                                              ),
                                            ),
                                            Column(
                                              children: <Widget>[
                                                _emailStatus
                                                    ? _getEmailEditIcon()
                                                    : Container(),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      if (!_emailStatus)
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 25.0,
                                              right: 25.0,
                                              top: 20.0),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 10.0),
                                                  child: Container(
                                                    child: RaisedButton(
                                                      child: Text('Vista'),
                                                      textColor: Colors.white,
                                                      color: Colors.green,
                                                      onPressed: () async {
                                                        if (_emailKey
                                                            .currentState
                                                            .validate()) {
                                                          try {
                                                            await _auth
                                                                .changeEmail(
                                                                    _currentEmail);
                                                            await DatabaseService(
                                                                    uid: user
                                                                        .uid)
                                                                .updateUserData(
                                                              userData.name,
                                                              _currentEmail ??
                                                                  userData
                                                                      .email,
                                                              userData
                                                                  .residentAssociationId,
                                                              userData
                                                                  .apartmentId,
                                                              userData.isAdmin,
                                                            );
                                                            setState(() {
                                                              _emailStatus =
                                                                  true;
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      FocusNode());
                                                            });
                                                          } on Exception catch (error) {
                                                            print('email can\'t be changed' +
                                                                error
                                                                    .toString());
                                                          }
                                                        }
                                                      },
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0)),
                                                    ),
                                                  ),
                                                ),
                                                flex: 2,
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10.0),
                                                  child: Container(
                                                    child: RaisedButton(
                                                      child: Text('Hætta við'),
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
                                                    ),
                                                  ),
                                                ),
                                                flex: 2,
                                              )
                                            ],
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                child: Form(
                                  key: _passwordKey,
                                  child: Column(
                                    children: <Widget>[
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
                                                  'Nýtt lykilorð',
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 25.0, right: 25.0, top: 2.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Flexible(
                                              child: TextFormField(
                                                obscureText: true,
                                                decoration: InputDecoration(
                                                    hintText:
                                                        'Skráðu inn nýtt lykilorð'),
                                                validator: (value) => value
                                                            .length <
                                                        6
                                                    ? 'Lykilorð þarf að innihalda 6+ stafi'
                                                    : null,
                                                onChanged: (value) => setState(
                                                    () => _currentPassword =
                                                        value),
                                                enabled: !_passwordStatus,
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                _passwordStatus
                                                    ? _getPasswordEditIcon()
                                                    : Container(),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      if (!_passwordStatus)
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 25.0,
                                              right: 25.0,
                                              top: 20.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 10.0),
                                                  child: Container(
                                                    child: RaisedButton(
                                                      child: Text('Vista'),
                                                      textColor: Colors.white,
                                                      color: Colors.green,
                                                      onPressed: () async {
                                                        if (_passwordKey
                                                            .currentState
                                                            .validate()) {
                                                          try {
                                                            await _auth
                                                                .changePassword(
                                                                    _currentPassword);
                                                            setState(() {
                                                              _passwordStatus =
                                                                  true;
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      FocusNode());
                                                            });
                                                          } catch (error) {
                                                            print('Password can\'t be changed' +
                                                                error
                                                                    .toString());
                                                          }
                                                        }
                                                      },
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0)),
                                                    ),
                                                  ),
                                                ),
                                                flex: 2,
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10.0),
                                                  child: Container(
                                                    child: RaisedButton(
                                                      child: Text('Hætta við'),
                                                      textColor: Colors.white,
                                                      color: Colors.red,
                                                      onPressed: () {
                                                        setState(() {
                                                          _passwordStatus =
                                                              true;
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
                                                    ),
                                                  ),
                                                ),
                                                flex: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(
                    //   height: 100,
                    // ),
                    // deleteButton(),
                  ],
                ),
              ),
            );
          } else {
            return LoadingSpinner();
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
        });
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
        });
  }

  Widget _getPasswordEditIcon() {
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
            _passwordStatus = false;
          });
        });
  }

  Widget deleteButton() {
    return GestureDetector(
      onTap: () async {
        _popupDialog(context);
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(23),
          color: Colors.red,
        ),
        child: Center(
          child: Text(
            'Eyða Aðgangi',
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
            title: Text('Ert þú viss um að þú viljir eyða aðganginum þínum?'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    _auth.deleteUser();
                  },
                  child: Text('Já')),
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Nei')),
            ],
          );
        });
  }
}
