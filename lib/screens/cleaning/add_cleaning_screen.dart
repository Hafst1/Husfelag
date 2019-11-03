import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/cleaning_provider.dart';
import '../../models/cleaning.dart';
import '../../widgets/save_button.dart';
import '../../widgets/home_option.dart';

class AddCleaningScreen extends StatefulWidget {
  static const routeName = '/add-cleaning';

  @override
  _AddCleaningScreenState createState() => _AddCleaningScreenState();
}

class _AddCleaningScreenState extends State<AddCleaningScreen> {
  final _dateFromController = TextEditingController();
  final _dateToController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _newCleaningItem = Cleaning(
    id: null,
    apartment: "",
    dateFrom: DateTime.now(),
    dateTo: DateTime.now(),
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
      initialDate: convertToDate(controller.text) ?? exactDate,
      firstDate: exactDate.subtract(
        Duration(days: 30),
      ),
      lastDate: exactDate.add(
        Duration(days: 1825),
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
    Provider.of<CleaningProvider>(context, listen: false)
        .addCleaningItem(_newCleaningItem);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bæta við þrif"),
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
          child: Column(children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                hintText: "Íbúð...",
                prefixIcon: Icon(Icons.home),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return "Útvega þarf íbúð fyrir þrif á sameign!";
                }
                return null;
              },
              onSaved: (value) {
                _newCleaningItem = Cleaning(
                  id: _newCleaningItem.id,
                  apartment: value,
                  dateFrom: _newCleaningItem.dateFrom,
                  dateTo: _newCleaningItem.dateTo,
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
                      return "Fylla þarf út upphafsdagsetningu þrifa!";
                    }
                    if (_dateToController.text.isNotEmpty) {
                      if (convertToDate(value)
                          .isAfter(convertToDate(_dateToController.text))) {
                        return "Valin dagsetning á sér stað á eftir lokadagsetningu þrifa!";
                      }
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _newCleaningItem = Cleaning(
                      id: _newCleaningItem.id,
                      apartment: _newCleaningItem.apartment,
                      dateFrom: convertToDate(value),
                      dateTo: _newCleaningItem.dateTo,
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
                      return "Fylla þarf út lokadagsetningu þrifa!";
                    }
                    if (_dateFromController.text.isNotEmpty) {
                      if (convertToDate(value)
                          .isBefore(convertToDate(_dateFromController.text))) {
                        return "Valin dagsetning á sér stað á undan upphafsdagsetningu þrifa!";
                      }
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _newCleaningItem = Cleaning(
                      id: _newCleaningItem.id,
                      apartment: _newCleaningItem.apartment,
                      dateFrom: _newCleaningItem.dateFrom,
                      dateTo: convertToDate(value),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            SaveButton(saveFunc: _saveForm),
          ]),
        ),
      ),
    );
  }
}
