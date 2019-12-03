import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import '../../providers/cleaning_provider.dart';
import '../../providers/current_user_provider.dart';
import '../../models/cleaning.dart';
import '../../widgets/save_button.dart';
import './apartment_picker_screen.dart';
import '../../shared/loading_spinner.dart';

class AddCleaningScreen extends StatefulWidget {
  static const routeName = '/add-cleaning';

  @override
  _AddCleaningScreenState createState() => _AddCleaningScreenState();
}

class _AddCleaningScreenState extends State<AddCleaningScreen> {
  final _apartmentController = TextEditingController();
  final _dateFromController = TextEditingController();
  final _dateToController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _cleaningItem = Cleaning(
    id: null,
    apartment: '',
    dateFrom: DateTime.now(),
    dateTo: DateTime.now(),
    authorId: '',
  );

  var _initValues = {
    'appbar-title': 'Bæta við þrif',
    'save-text': 'BÆTA VIÐ',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final cleaningId = ModalRoute.of(context).settings.arguments as String;
      if (cleaningId != null) {
        _cleaningItem = Provider.of<CleaningProvider>(context, listen: false)
            .findById(cleaningId);
        _initValues = {
          'appbar-title': 'Breyta þrifum',
          'save-text': 'BREYTA',
        };
        _apartmentController.text = _cleaningItem.apartment;
        _dateFromController.text =
            DateFormat.yMMMMEEEEd().format(_cleaningItem.dateFrom);
        _dateToController.text =
            DateFormat.yMMMMEEEEd().format(_cleaningItem.dateTo);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _apartmentController.dispose();
    _dateFromController.dispose();
    _dateToController.dispose();
    super.dispose();
  }

  void _presentApartmentPicker() async {
    String apartment =
        await Navigator.of(context).push(MaterialPageRoute<String>(
            builder: (BuildContext context) {
              return ApartMentPickerScreen();
            },
            fullscreenDialog: true));
    if (apartment != null) {
      setState(() {
        _apartmentController.text = apartment;
      });
    }
  }

  void _presentDatePicker(TextEditingController controller) {
    DateTime exactDate = DateTime.now();
    final convertedDate = convertToDate(controller.text) ?? exactDate;
    final firstDate = exactDate.subtract(
      Duration(days: 30),
    );
    showDatePicker(
      context: context,
      initialDate:
          convertedDate.isBefore(firstDate) ? firstDate : convertedDate,
      firstDate: firstDate,
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

  void _saveForm(String residentAssociationId) async {
    var isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_cleaningItem.id != null) {
      try {
        await Provider.of<CleaningProvider>(context, listen: false)
            .updateCleaningItem(residentAssociationId, _cleaningItem);
      } catch (error) {
        await printErrorDialog('Ekki tókst að breyta þrifum!');
      }
    } else {
      try {
        await Provider.of<CleaningProvider>(context, listen: false)
            .addCleaningItem(residentAssociationId, _cleaningItem);
      } catch (error) {
        await printErrorDialog('Ekki tókst að bæta við þrif!');
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
    final currentUserData =
        Provider.of<CurrentUserProvider>(context, listen: false);
    final residentAssociationId = currentUserData.getResidentAssociationId();
    final userId = currentUserData.getId();
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
                    _saveForm(residentAssociationId);
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
                    GestureDetector(
                      onTap: () => _presentApartmentPicker(),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _apartmentController,
                          decoration: InputDecoration(
                            hintText: "Íbúð...",
                            prefixIcon: Icon(Icons.home),
                            prefixText:
                                _apartmentController.text != "" ? "Íbúð: " : "",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Velja þarf íbúð fyrir þrif á sameign!";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _cleaningItem = Cleaning(
                              id: _cleaningItem.id,
                              apartment: value,
                              dateFrom: _cleaningItem.dateFrom,
                              dateTo: _cleaningItem.dateTo,
                              authorId: _cleaningItem.authorId != ''
                                  ? _cleaningItem.authorId
                                  : userId,
                            );
                          },
                        ),
                      ),
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
                              return "Fylla þarf út upphafsdagsetningu þrifa!";
                            }
                            if (_dateToController.text.isNotEmpty) {
                              if (convertToDate(value).isAfter(
                                  convertToDate(_dateToController.text))) {
                                return "Valin dagsetning á sér stað á eftir lokadagsetningu þrifa!";
                              }
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _cleaningItem = Cleaning(
                              id: _cleaningItem.id,
                              apartment: _cleaningItem.apartment,
                              dateFrom: convertToDate(value),
                              dateTo: _cleaningItem.dateTo,
                              authorId: _cleaningItem.authorId,
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
                              return "Fylla þarf út lokadagsetningu þrifa!";
                            }
                            if (_dateFromController.text.isNotEmpty) {
                              if (convertToDate(value).isBefore(
                                  convertToDate(_dateFromController.text))) {
                                return "Valin dagsetning á sér stað á undan upphafsdagsetningu þrifa!";
                              }
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _cleaningItem = Cleaning(
                              id: _cleaningItem.id,
                              apartment: _cleaningItem.apartment,
                              dateFrom: _cleaningItem.dateFrom,
                              dateTo: convertToDate(value),
                              authorId: _cleaningItem.authorId,
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Platform.isAndroid
                        ? SaveButton(
                            text: _initValues['save-text'],
                            saveFunc: () => _saveForm(residentAssociationId),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
    );
  }
}
