import 'package:flutter/material.dart';

import '../../widgets/custom_icons_icons.dart';
import '../../models/resident_association.dart';
import '../../widgets/save_button.dart';
import '../../providers/current_user.dart';

class CreateAssociationScreen extends StatefulWidget {
  @override
  _CreateAssociationScreenState createState() =>
      _CreateAssociationScreenState();
}

class _CreateAssociationScreenState extends State<CreateAssociationScreen> {
  final _form = GlobalKey<FormState>();
  var _newAssociation = ResidentAssociation(
    id: null,
    name: '',
    address: '',
    description: '',
    accessCode: '',
  );
  var _creatorsApartmentNumber = '';

  void _saveForm() async {
    var isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();

    print(_newAssociation.id);
    print(_newAssociation.name);
    print(_newAssociation.address);
    print(_newAssociation.description);
    print(_newAssociation.accessCode);
    print(_creatorsApartmentNumber);

    try {

    } catch (error) {

    }

    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stofna húsfélag'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Heiti húsfélags...",
                  prefixIcon: Icon(CustomIcons.pencil),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Fylla þarf út heiti húsfélags!";
                  }
                  if (value.length > 40) {
                    return "Heiti húsfélags getur ekki verið meira en 40 stafir á lengd!";
                  }
                  return null;
                },
                onSaved: (value) {
                  _newAssociation = ResidentAssociation(
                    id: _newAssociation.id,
                    name: value,
                    address: _newAssociation.address,
                    description: _newAssociation.description,
                    accessCode: _newAssociation.accessCode,
                  );
                },
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Heimilisfang...",
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
                  return null;
                },
                onSaved: (value) {
                  _newAssociation = ResidentAssociation(
                    id: _newAssociation.id,
                    name: _newAssociation.name,
                    address: value,
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
                    name: _newAssociation.name,
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
                  _creatorsApartmentNumber = value;
                },
              ),
              SizedBox(
                height: 15,
              ),
              SaveButton(
                text: 'STOFNA',
                saveFunc: _saveForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
