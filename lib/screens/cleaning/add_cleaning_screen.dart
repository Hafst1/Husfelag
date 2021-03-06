import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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
    apartmentNumber: '',
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

  // if we there was a cleaning item id passed in through arguments then the
  // text fields will contain the value of that particular cleaning item.
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
        _apartmentController.text = _cleaningItem.apartmentNumber;
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

  // function which presents a page where you can pick one of the
  // apartments in the resident association.
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

  // function which presents a date picker.
  void _presentDatePicker(TextEditingController controller) {
    DateTime exactDate = DateTime.now();
    final convertedDate = _convertToDate(controller.text) ?? exactDate;
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

  // function which convert a string formatted date to a DateTime object.
  DateTime _convertToDate(String input) {
    try {
      var d = DateFormat.yMMMMEEEEd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  // function which validates the form and if it is valid it is saved and
  // added to the database.
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
        await _printErrorDialog('Ekki tókst að breyta þrifum!');
      }
    } else {
      try {
        await Provider.of<CleaningProvider>(context, listen: false)
            .addCleaningItem(residentAssociationId, _cleaningItem);
      } catch (error) {
        await _printErrorDialog('Ekki tókst að bæta við þrif!');
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  // function which prints an error dialog
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

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    final currentUserData =
        Provider.of<CurrentUserProvider>(context, listen: false);
    final residentAssociationId = currentUserData.getResidentAssociationId();
    final userId = currentUserData.getId();
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = AppBar(
      title: Text(_initValues['appbar-title']),
      centerTitle: true,
      actions: <Widget>[
        platform == TargetPlatform.iOS
            ? IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _saveForm(residentAssociationId);
                })
            : Container(),
      ],
    );
    final heightOfBody = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height -
        kBottomNavigationBarHeight;
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
                      GestureDetector(
                        onTap: () => _presentApartmentPicker(),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _apartmentController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Íbúð...',
                              prefixIcon: Icon(Icons.home),
                              prefixText: _apartmentController.text != ''
                                  ? 'Íbúð: '
                                  : '',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Velja þarf íbúð fyrir þrif á sameign!';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _cleaningItem = Cleaning(
                                id: _cleaningItem.id,
                                apartmentNumber: value,
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
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Frá...',
                              prefixText:
                                  _dateFromController.text != '' ? 'Frá: ' : '',
                              prefixIcon: Icon(Icons.date_range),
                              errorMaxLines: 2,
                            ),
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Fylla þarf út upphafsdagsetningu þrifa!';
                              }
                              if (_dateToController.text.isNotEmpty) {
                                if (_convertToDate(value).isAfter(
                                    _convertToDate(_dateToController.text))) {
                                  return 'Valin dagsetning á sér stað á eftir lokadagsetningu þrifa!';
                                }
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _cleaningItem = Cleaning(
                                id: _cleaningItem.id,
                                apartmentNumber: _cleaningItem.apartmentNumber,
                                dateFrom: _convertToDate(value),
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
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Til...',
                              prefixText:
                                  _dateToController.text != '' ? 'Til: ' : '',
                              prefixIcon: Icon(Icons.date_range),
                              errorMaxLines: 2,
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Fylla þarf út lokadagsetningu þrifa!';
                              }
                              if (_dateFromController.text.isNotEmpty) {
                                if (_convertToDate(value).isBefore(
                                    _convertToDate(_dateFromController.text))) {
                                  return 'Valin dagsetning á sér stað á undan upphafsdagsetningu þrifa!';
                                }
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _cleaningItem = Cleaning(
                                id: _cleaningItem.id,
                                apartmentNumber: _cleaningItem.apartmentNumber,
                                dateFrom: _cleaningItem.dateFrom,
                                dateTo: _convertToDate(value),
                                authorId: _cleaningItem.authorId,
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      platform == TargetPlatform.android
                          ? SaveButton(
                              text: _initValues['save-text'],
                              saveFunc: () => _saveForm(residentAssociationId),
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
