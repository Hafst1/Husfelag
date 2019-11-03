import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/constructions_provider.dart';
import '../../widgets/custom_icons_icons.dart';
import '../../models/construction.dart';
import '../../widgets/save_button.dart';

class AddConstructionScreen extends StatefulWidget {
  static const routeName = '/add-construction';

  @override
  _AddConstructionScreenState createState() => _AddConstructionScreenState();
}

class _AddConstructionScreenState extends State<AddConstructionScreen> {
  final _dateFromController = TextEditingController();
  final _dateToController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _newConstruction = Construction(
    id: null,
    title: "",
    dateFrom: DateTime.now(),
    dateTo: DateTime.now(),
    description: "",
  );

  @override
  void dispose() {
    _dateFromController.dispose();
    _dateToController.dispose();
    super.dispose();
  }

  void _presentDatePicker(TextEditingController controller) {
    DateTime exactDate = DateTime.now();
    showDatePicker(
      context: context,
      initialDate: convertToDate(controller.text) ?? DateTime.now(),
      firstDate: exactDate.subtract(
        Duration(days: 3650),
      ),
      lastDate: exactDate.add(
        Duration(days: 3650),
      ),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        controller.text = DateFormat.yMMMMEEEEd().format(pickedDate);
      });
    });
  }

  DateTime convertToDate(String input) {
    try {
      var d = new DateFormat.yMMMMEEEEd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  void _saveForm() {
    var isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    Provider.of<ConstructionsProvider>(context, listen: false)
        .addConstruction(_newConstruction);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bæta við framkvæmd"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _saveForm();
              }),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Titill...",
                  prefixIcon: Icon(CustomIcons.pencil),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Titill framkvæmdar getur ekki verið tómur strengur!";
                  }
                  if (value.length > 40) {
                    return "Titill framkvæmdar getur ekki verið meira en 40 stafir á lengd!";
                  }
                  return null;
                },
                onSaved: (value) {
                  _newConstruction = Construction(
                    id: _newConstruction.id,
                    title: value,
                    dateFrom: _newConstruction.dateFrom,
                    dateTo: _newConstruction.dateTo,
                    description: _newConstruction.description,
                  );
                },
              ),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () => _presentDatePicker(_dateFromController),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateFromController,
                    decoration: InputDecoration(
                      hintText: "Frá...",
                      prefixText: _dateFromController.text != "" ? "Frá: " : "",
                      prefixIcon: Icon(Icons.date_range),
                      border: OutlineInputBorder(),
                      errorMaxLines: 2,
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Fylla þarf út upphafsdagsetningu framkvæmdar!";
                      }
                      if (_dateToController.text.isNotEmpty) {
                        if (convertToDate(value)
                            .isAfter(convertToDate(_dateToController.text))) {
                          return "Valin dagsetning á sér stað á eftir lokadagsetningu framkvæmdar!";
                        }
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _newConstruction = Construction(
                        id: _newConstruction.id,
                        title: _newConstruction.title,
                        dateFrom: convertToDate(value),
                        dateTo: _newConstruction.dateTo,
                        description: _newConstruction.description,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () => _presentDatePicker(_dateToController),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _dateToController,
                    decoration: InputDecoration(
                      hintText: "Til...",
                      prefixText: _dateToController.text != "" ? "Til: " : "",
                      prefixIcon: Icon(Icons.date_range),
                      border: OutlineInputBorder(),
                      errorMaxLines: 2,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Fylla þarf út lokadagsetningu framkvæmdar!";
                      }
                      if (_dateFromController.text.isNotEmpty) {
                        if (convertToDate(value).isBefore(
                            convertToDate(_dateFromController.text))) {
                          return "Valin dagsetning á sér stað á undan upphafsdagsetningu framkvæmdar!";
                        }
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _newConstruction = Construction(
                        id: _newConstruction.id,
                        title: _newConstruction.title,
                        dateFrom: _newConstruction.dateFrom,
                        dateTo: convertToDate(value),
                        description: _newConstruction.description,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: "Nánari lýsing...",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.length < 10) {
                    return "Lýsing framkvæmdar þarf að vera a.m.k. 10 stafir á lengd!";
                  }
                  return null;
                },
                onSaved: (value) {
                  _newConstruction = Construction(
                    id: _newConstruction.id,
                    title: _newConstruction.title,
                    dateFrom: _newConstruction.dateFrom,
                    dateTo: _newConstruction.dateTo,
                    description: value,
                  );
                },
              ),
              SizedBox(
                height: 15,
              ),
              SaveButton(saveFunc: _saveForm),
            ],
          ),
        ),
      ),
    );
  }
}
