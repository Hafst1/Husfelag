import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../models/resident_association.dart';
import '../../models/apartment.dart';
import '../../widgets/save_button.dart';
import '../../providers/current_user_provider.dart';
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
      Provider.of<CurrentUserProvider>(context)
          .fetchAssociations(context)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  // function which validates and saves form, if succesful it will try to add the
  // resident association to firebase.
  void _saveForm() async {
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
          await Provider.of<CurrentUserProvider>(context, listen: false)
              .createAssociation(_newAssociation, _newApartment);
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
        content: Text('Aðgangskóði húsfélagsins er: ' +
            accessCode +
            '\n\nAðrir meðlimir geta notað þennan kóða til þess að ganga í húsfélagið!'),
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

  @override
  Widget build(BuildContext context) {
    final currentUserData = Provider.of<CurrentUserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Stofna húsfélag'),
        centerTitle: true,
        actions: <Widget>[
          Platform.isIOS
              ? IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _saveForm();
                  })
              : Container(),
        ],
      ),
      body: _isLoading
          ? LoadingSpinner()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Heimilisfang húsfélags...",
                        prefixIcon: Icon(Icons.location_on),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Fylla þarft út heimilisfang!";
                        }
                        if (value.length > 40) {
                          return "Heimilisfang getur ekki verið meira en 40 stafir á lengd!";
                        }
                        if (!currentUserData
                            .associationAddressIsAvailable(value)) {
                          return "Viðkomandi heimilisfang er nú þegar frátekið!";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _newAssociation = ResidentAssociation(
                          id: _newAssociation.id,
                          address:
                              '${value[0].toUpperCase()}${value.substring(1)}',
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
                        hintText: "Nánari lýsing (valfrjálst)...",
                        border: OutlineInputBorder(),
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
                        hintText: "Þitt íbúðarnúmer...",
                        prefixIcon: Icon(Icons.home),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Fylla þarf út íbúðarnúmer!";
                        }
                        if (value.length > 4) {
                          return "Íbúðarnúmer getur ekki verið lengra en 4 stafir á lengd!";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _newApartment = Apartment(
                          id: _newApartment.id,
                          apartmentNumber: value,
                          accessCode: _newApartment.accessCode,
                          residents: [currentUserData.getId()],
                        );
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Aðgangskóði íbúðar...",
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: Icon(Icons.visibility_off),
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value.length < 6) {
                          return "Lykilorð þarf að vera að minnsta kosti 6 stafir á lengd!";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _newApartment = Apartment(
                          id: _newApartment.id,
                          apartmentNumber: _newApartment.apartmentNumber,
                          accessCode: value,
                          residents: [currentUserData.getId()],
                        );
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Platform.isAndroid
                        ? SaveButton(
                            text: 'STOFNA',
                            saveFunc: _saveForm,
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
    );
  }
}
