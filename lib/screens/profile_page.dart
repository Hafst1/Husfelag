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

  Widget buildPadding(String name) {
    return Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
        child: Row(
          children: <Widget>[
            Text(
              name,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }

  Widget buildInputField(var value, String textHint, Function valCheck,
      Function changed, bool currStatus, var editIcon) {
    return Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextFormField(
                initialValue: value,
                decoration: InputDecoration(
                  hintText: textHint,
                ),
                validator: valCheck,
                onChanged: changed,
                enabled: !currStatus,
                autofocus: !currStatus,
              ),
            ),
            Column(
              children: <Widget>[
                currStatus ? editIcon : Container(),
              ],
            )
          ],
        ));
  }

  Widget buildSaveButton(Function updateData) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: 10.0),
        child: Container(
            child: RaisedButton(
          child: Text('Vista'),
          textColor: Colors.white,
          color: Colors.green,
          onPressed: updateData,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        )),
      ),
      flex: 2,
    );
  }

  Widget buildStopButton(Function stateChange) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: Container(
          child: RaisedButton(
            child: Text('Hætta við'),
            textColor: Colors.white,
            color: Colors.red,
            onPressed: stateChange,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
          ),
        ),
      ),
      flex: 2,
    );
  }

  Future<void> printErrorDialog(String errorMessage) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Villa kom upp'),
        content: Text(errorMessage),
        actions: <Widget>[
          FlatButton(
            child: Text('Halda áfram'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
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
                    style: TextStyle(fontSize: 20.0, color: Colors.white)),
              ),
              body: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      ListView(
                        shrinkWrap: true,
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
                                            buildPadding('Nafn'),
                                            buildInputField(
                                                userData.name,
                                                'Skráðu nafnið þitt',
                                                (val) => val.isEmpty
                                                    ? 'Vinsamlegast skráðu nafn'
                                                    : null,
                                                (val) => setState(
                                                    () => _currentName = val),
                                                _nameStatus,
                                                _getEditIcon(() {
                                                  setState(() {
                                                    _nameStatus = false;
                                                  });
                                                })),
                                            if (!_nameStatus)
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 25.0,
                                                    right: 25.0,
                                                    top: 20.0),
                                                child: Row(
                                                  children: <Widget>[
                                                    buildSaveButton(() async {
                                                      if (_nameKey.currentState
                                                          .validate()) {
                                                        await DatabaseService(
                                                                uid: user.uid)
                                                            .updateUserData(
                                                                _currentName ??
                                                                    userData
                                                                        .name,
                                                                userData.email,
                                                                userData
                                                                    .residentAssociationId,
                                                                userData
                                                                    .apartmentId,
                                                                userData
                                                                    .isAdmin,
                                                                userData
                                                                    .userToken);
                                                        setState(() {
                                                          _nameStatus = true;
                                                          FocusScope.of(context)
                                                              .requestFocus(
                                                                  FocusNode());
                                                        });
                                                      }
                                                    }),
                                                    buildStopButton(() {
                                                      setState(() {
                                                        _nameStatus = true;
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                FocusNode());
                                                      });
                                                    }),
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
                                            buildPadding('Netfang'),
                                            buildInputField(
                                                userData.email,
                                                'Skráðu netfangið þitt',
                                                (val) => val.isEmpty
                                                    ? 'Vinsamlegast sláðu inn netfang'
                                                    : null,
                                                (val) => setState(
                                                    () => _currentEmail = val),
                                                _emailStatus,
                                                _getEditIcon(() {
                                                  setState(() {
                                                    _emailStatus = false;
                                                  });
                                                })),
                                            if (!_emailStatus)
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 25.0,
                                                    right: 25.0,
                                                    top: 20.0),
                                                child: Row(
                                                  children: <Widget>[
                                                    buildSaveButton(
                                                      () async {
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
                                                                    userData
                                                                        .name,
                                                                    _currentEmail ??
                                                                        userData
                                                                            .email,
                                                                    userData
                                                                        .residentAssociationId,
                                                                    userData
                                                                        .apartmentId,
                                                                    userData
                                                                        .isAdmin,
                                                                    userData
                                                                        .userToken);
                                                            setState(() {
                                                              _emailStatus =
                                                                  true;
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus(
                                                                      FocusNode());
                                                            });
                                                          } catch (error) {
                                                            await printErrorDialog(
                                                                'Þú þarft að vera nýskráð/ur inn til að breyta þessum upplýsingum');
                                                          }
                                                        }
                                                      },
                                                    ),
                                                    buildStopButton(() {
                                                      setState(() {
                                                        _emailStatus = true;
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                FocusNode());
                                                      });
                                                    }),
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
                                            buildPadding('Nýtt lykilorð'),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 25.0,
                                                  right: 25.0,
                                                  top: 2.0),
                                              child: Row(
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
                                                      onChanged: (value) =>
                                                          setState(() =>
                                                              _currentPassword =
                                                                  value),
                                                      enabled: !_passwordStatus,
                                                    ),
                                                  ),
                                                  Column(
                                                    children: <Widget>[
                                                      _passwordStatus
                                                          ? _getEditIcon(() {
                                                              setState(() {
                                                                _passwordStatus = false;
                                                              });
                                                            })
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
                                                  children: <Widget>[
                                                    buildSaveButton(() async {
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
                                                            await printErrorDialog(
                                                                'Þú þarft að vera nýskráð/ur inn til að breyta þessum upplýsingum');
                                                          }
                                                      }
                                                    }),
                                                    buildStopButton(() {
                                                      setState(() {
                                                        _passwordStatus = true;
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                FocusNode());
                                                      });
                                                    }),
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
                        ],
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      _deleteButton(),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return LoadingSpinner();
          }
        });
  }

    Widget _getEditIcon(Function getState) {
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
        onTap: getState,
      );
  }

  Widget _deleteButton() {
    return GestureDetector(
      onTap: () async {
        _popupDialog(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 30,
        ),
        height: 50,
        width: MediaQuery.of(context).size.width * 0.5,
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
                    try {
                      _auth.deleteUser();
                    } catch (error) {
                      print(error.toString());
                    }
                    Navigator.of(context).pop();
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
