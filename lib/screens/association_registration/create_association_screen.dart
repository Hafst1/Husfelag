import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/resident_association.dart';
import '../../models/apartment.dart';
import '../../models/user.dart';
import '../../widgets/save_button.dart';
import '../../providers/current_user_provider.dart';
import '../../providers/association_provider.dart';
import '../../shared/loading_spinner.dart';

class CreateAssociationScreen extends StatefulWidget {
  @override
  _CreateAssociationScreenState createState() =>
      _CreateAssociationScreenState();
}

class _CreateAssociationScreenState extends State<CreateAssociationScreen> {
  final _form = GlobalKey<FormState>();
  var _newAssociation = ResidentAssociation(
    id: null,
    address: '',
    description: '',
    accessCode: '',
  );
  var _newApartment = Apartment(
    id: null,
    apartmentNumber: '',
    accessCode: '',
    residents: List<String>(),
  );
  var _isInit = true;
  var _isLoading = false;

  // fetch associations before widget is built.
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<AssociationsProvider>(context).fetchAssociations().then((_) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((_) {
        setState(() {
          _isLoading = false;
        });
        _printErrorDialog('Eitthvað fór úrskeiðis!');
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  // function which validates and saves form, if succesful it will try to add the
  // resident association to firebase.
  void _saveForm(UserData newUser) async {
    var isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      final response =
          await Provider.of<AssociationsProvider>(context, listen: false)
              .createAssociation(_newAssociation, _newApartment, newUser);
      await _printConfirmationDialog(response);
    } catch (error) {
      await _printErrorDialog('Ekki tókst að stofna húsfélag!');
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  // function which presents an error dialog.
  Future<void> _printErrorDialog(String errorMessage) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Villa kom upp'),
        content: Text(errorMessage),
        actions: <Widget>[
          FlatButton(
            child: Text('Halda áfram'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  // function which presenets a confirmation dialog.
  Future<void> _printConfirmationDialog(String accessCode) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Þú hefur stofnað húsfélag!'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Aðgangskóði húsfélagsins er:'),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 40),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: FittedBox(
                      child: Text(accessCode),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
                'Aðrir meðlimir geta notað þennan kóða til þess að ganga í húsfélagið!'),
            SizedBox(
              height: 15,
            ),
            Text(
                'ATH: Hægt er að breyta aðgangskóðanum á síðunni "Mitt húsfélag".'),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Halda áfram',
              style: TextStyle(
                color: Colors.green[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  // function which explains the purpose of apartment access code.
  void _presentAccessCodeExplanationDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Aðgangskóði íbúðar'),
        content: Text(
            'Aðgangskóði íbúðar er lykilorð sem annar aðili þarf að útvega ætli hann að ganga í tiltekna íbúð.'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Halda áfram',
              style: TextStyle(
                color: Colors.green[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var platform = Theme.of(context).platform;
    final currentUser = Provider.of<CurrentUserProvider>(context).getUser();
    final associationsData = Provider.of<AssociationsProvider>(context);
    final mediaQuery = MediaQuery.of(context);
    final appBar = AppBar(
      title: Text('Stofna húsfélag'),
      centerTitle: true,
      actions: <Widget>[
        platform == TargetPlatform.iOS
            ? IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _saveForm(currentUser);
                })
            : Container(),
      ],
    );
    final heightOfBody = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height;
    return Scaffold(
      appBar: appBar,
      body: _isLoading
          ? LoadingSpinner()
          : Container(
              height: heightOfBody,
              color: Color.fromRGBO(230, 230, 230, 1),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _form,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Heimilisfang húsfélags...',
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.location_on),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Fylla þarft út heimilisfang!';
                          }
                          if (value.length > 30) {
                            return 'Heimilisfang getur ekki verið meira en 30 stafir á lengd!';
                          }
                          if (!associationsData
                              .associationAddressIsAvailable(value)) {
                            return 'Viðkomandi heimilisfang er nú þegar frátekið!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _newAssociation = ResidentAssociation(
                            id: _newAssociation.id,
                            address:
                                '${value[0].toUpperCase()}${value.substring(1).toLowerCase()}',
                            description: _newAssociation.description,
                            accessCode: _newAssociation.accessCode,
                          );
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        maxLines: 10,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Nánari lýsing (valfrjálst)...',
                        ),
                        keyboardType: TextInputType.text,
                        onSaved: (value) {
                          _newAssociation = ResidentAssociation(
                            id: _newAssociation.id,
                            address: _newAssociation.address,
                            description: value,
                            accessCode: _newAssociation.accessCode,
                          );
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Þitt íbúðarnúmer...',
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.home),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Fylla þarf út íbúðarnúmer!';
                          }
                          if (value.length > 4) {
                            return 'Íbúðarnúmer getur ekki verið lengra en 4 stafir á lengd!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _newApartment = Apartment(
                            id: _newApartment.id,
                            apartmentNumber: value,
                            accessCode: _newApartment.accessCode,
                            residents: [currentUser.id],
                          );
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Aðgangskóði íbúðar...',
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: Icon(Icons.visibility_off),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value.length < 6) {
                            return 'Aðgangskóði þarf að vera að minnsta kosti 6 stafir á lengd!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _newApartment = Apartment(
                            id: _newApartment.id,
                            apartmentNumber: _newApartment.apartmentNumber,
                            accessCode: value,
                            residents: [currentUser.id],
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () =>
                                _presentAccessCodeExplanationDialog(),
                            child: Text(
                              'Aðgangskóði íbúðar?',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      platform == TargetPlatform.android
                          ? SaveButton(
                              text: 'STOFNA',
                              saveFunc: () => _saveForm(currentUser),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
