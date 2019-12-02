import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import '../../providers/constructions_provider.dart';
import '../../providers/current_user_provider.dart';
import '../../widgets/custom_icons_icons.dart';
import '../../models/construction.dart';
import '../../widgets/save_button.dart';
import '../../shared/loading_spinner.dart';

class AddConstructionScreen extends StatefulWidget {
  static const routeName = '/add-construction';

  @override
  _AddConstructionScreenState createState() => _AddConstructionScreenState();
}

class _AddConstructionScreenState extends State<AddConstructionScreen> {
  final _dateFromController = TextEditingController();
  final _dateToController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _construction = Construction(
    id: null,
    title: "",
    dateFrom: DateTime.now(),
    dateTo: DateTime.now(),
    description: "",
  );
  var _initValues = {
    'appbar-title': 'Bæta við framkvæmd',
    'title': '',
    'description': '',
    'save-text': 'BÆTA VIÐ',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final constructionId =
          ModalRoute.of(context).settings.arguments as String;
      if (constructionId != null) {
        _construction =
            Provider.of<ConstructionsProvider>(context, listen: false)
                .findById(constructionId);
        _initValues = {
          'appbar-title': 'Breyta framkvæmd',
          'title': _construction.title,
          'description': _construction.description,
          'save-text': 'BREYTA',
        };
        _dateFromController.text =
            DateFormat.yMMMMEEEEd().format(_construction.dateFrom);
        _dateToController.text =
            DateFormat.yMMMMEEEEd().format(_construction.dateTo);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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

  void _saveForm() async {
    var isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    final residentAssociationId =
        Provider.of<CurrentUserProvider>(context, listen: false)
            .getResidentAssociationId();
    if (_construction.id != null) {
      try {
        await Provider.of<ConstructionsProvider>(context, listen: false)
            .updateConstruction(residentAssociationId, _construction);
      } catch (error) {
        await printErrorDialog('Ekki tókst að breyta framkvæmd!');
      }
    } else {
      try {
        await Provider.of<ConstructionsProvider>(context, listen: false)
            .addConstruction(residentAssociationId, _construction);
      } catch (error) {
        await printErrorDialog('Ekki tókst að bæta við framkvæmd!');
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  Future<void> printErrorDialog(String errorMessage) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_initValues['appbar-title']),
        centerTitle: true,
        actions: <Widget>[
          Platform.isIOS
              ? IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _saveForm();
                  },
                )
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
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(
                        hintText: "Titill...",
                        prefixIcon: Icon(CustomIcons.pencil),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Fylla þarf út titil framkvæmdar!";
                        }
                        if (value.length > 40) {
                          return "Titill framkvæmdar getur ekki verið meira en 40 stafir á lengd!";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _construction = Construction(
                          id: _construction.id,
                          title: value,
                          dateFrom: _construction.dateFrom,
                          dateTo: _construction.dateTo,
                          description: _construction.description,
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
                            prefixText:
                                _dateFromController.text != "" ? "Frá: " : "",
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
                              if (convertToDate(value).isAfter(
                                  convertToDate(_dateToController.text))) {
                                return "Valin dagsetning á sér stað á eftir lokadagsetningu framkvæmdar!";
                              }
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _construction = Construction(
                              id: _construction.id,
                              title: _construction.title,
                              dateFrom: convertToDate(value),
                              dateTo: _construction.dateTo,
                              description: _construction.description,
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
                            prefixText:
                                _dateToController.text != "" ? "Til: " : "",
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
                            _construction = Construction(
                              id: _construction.id,
                              title: _construction.title,
                              dateFrom: _construction.dateFrom,
                              dateTo: convertToDate(value),
                              description: _construction.description,
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      maxLines: 10,
                      decoration: InputDecoration(
                        hintText: "Nánari lýsing (valfrjálst)...",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        _construction = Construction(
                          id: _construction.id,
                          title: _construction.title,
                          dateFrom: _construction.dateFrom,
                          dateTo: _construction.dateTo,
                          description: value,
                        );
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Platform.isAndroid
                        ? SaveButton(
                            text: _initValues['save-text'],
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
