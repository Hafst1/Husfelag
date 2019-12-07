import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/association_provider.dart';
import '../models/resident_association.dart';
import '../shared/loading_spinner.dart';
import '../widgets/save_button.dart';

class EditAssociationScreen extends StatefulWidget {
  @override
  _EditAssociationScreenState createState() => _EditAssociationScreenState();
}

class _EditAssociationScreenState extends State<EditAssociationScreen> {
  final _form = GlobalKey<FormState>();
  var _association = ResidentAssociation(
    id: '',
    address: '',
    accessCode: '',
    description: '',
  );

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _association =
          ModalRoute.of(context).settings.arguments as ResidentAssociation;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
      await Provider.of<AssociationsProvider>(context)
          .updateAssociation(_association);
    } catch (error) {
      await _printErrorDialog('Ekki tókst að breyta upplýsingum um húsfélag!');
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Breyta upplýsingum'),
        centerTitle: true,
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
                      initialValue: _association.accessCode,
                      decoration: InputDecoration(
                        hintText: 'Aðgangskóði...',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                        errorMaxLines: 2,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Fylla þarft út aðgangskóða!';
                        }
                        if (value.length < 6) {
                          return 'Aðgangskóði þarf að vera að minnsta kosti 6 stafir á lengd!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _association = ResidentAssociation(
                          id: _association.id,
                          address: _association.address,
                          accessCode: value,
                          description: _association.description,
                        );
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      maxLines: 10,
                      initialValue: _association.description,
                      decoration: InputDecoration(
                        hintText: 'Nánari lýsing (valfrjálst)...',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        _association = ResidentAssociation(
                          id: _association.id,
                          address: _association.address,
                          accessCode: _association.accessCode,
                          description: value,
                        );
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SaveButton(
                      text: 'BREYTA',
                      saveFunc: _saveForm,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
