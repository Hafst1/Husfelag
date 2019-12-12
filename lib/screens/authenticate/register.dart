import 'package:flutter/material.dart';

import '../../services/auth.dart';
import '../../services/database.dart';
import '../../shared/loading_spinner.dart';
import '../../models/user.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;

  var _user = UserData(
    id: '',
    name: '',
    email: '',
    residentAssociationId: '',
    apartmentId: '',
    isAdmin: false,
    userToken: '',
  );

  var _userPassword = '';
  var _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Scaffold(
            body: LoadingSpinner(),
          )
        : Scaffold(
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      top: 50,
                    ),
                    child: Text(
                      'Búa til aðgang',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
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
                                hintText: 'Fullt nafn',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              validator: (val) =>
                                  val.isEmpty ? 'Sláðu inn fullt nafn' : null,
                              onChanged: (val) {
                                _user = UserData(
                                  id: _user.id,
                                  name: val,
                                  email: _user.email,
                                  residentAssociationId:
                                      _user.residentAssociationId,
                                  apartmentId: _user.apartmentId,
                                  isAdmin: _user.isAdmin,
                                  userToken: _user.userToken,
                                );
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Netfang',
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              validator: (val) =>
                                  val.isEmpty ? 'Sláðu inn netfang' : null,
                              onChanged: (val) {
                                _user = UserData(
                                  id: _user.id,
                                  name: _user.name,
                                  email: val,
                                  residentAssociationId:
                                      _user.residentAssociationId,
                                  apartmentId: _user.apartmentId,
                                  isAdmin: _user.isAdmin,
                                  userToken: _user.userToken,
                                );
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Lykilorð',
                                  prefixIcon: Icon(Icons.lock),
                                  suffixIcon: Icon(Icons.visibility_off),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                                obscureText: true,
                                validator: (val) => val.length < 6
                                    ? 'Lykilorð þarf að vera að minnsta kosti 6 stafir á lengd!'
                                    : null,
                                onChanged: (val) {
                                  _userPassword = val;
                                }),
                            SizedBox(
                              height: 60,
                            ),
                            _buildButton(),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Ertu nú þegar með aðgang?',
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
                                    'Skráðu þig inn!',
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
                              _errorMessage,
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

  // a button that activates the register user with firebase
  Widget _buildButton() {
    return GestureDetector(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          setState(() => _isLoading = true);
          try {
            dynamic result = await _auth.registerWithEmailAndPassword(
                _user.email, _userPassword);
            if (result != null) {
              await DatabaseService(uid: result.uid).updateUserData(
                _user.name,
                _user.email,
                _user.residentAssociationId,
                _user.apartmentId,
                _user.isAdmin,
                _user.userToken,
              );
            }
            if (this.mounted) {
              if (result == null) {
                setState(() {
                  _errorMessage = 'Vinsamlegast fylltu út gilt netfang';
                  _isLoading = false;
                });
              }
            }
          } catch (error) {
            // error handling
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
            'STOFNA AÐGANG',
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
