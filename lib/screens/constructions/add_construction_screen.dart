import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../providers/constructions_provider.dart';
import '../../providers/current_user_provider.dart';
import '../../providers/notification_provider.dart';
import '../../models/construction.dart';
import '../../models/notification.dart';
import '../../widgets/save_button.dart';
import '../../shared/loading_spinner.dart';
import '../../shared/constants.dart' as Constants;

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
    title: '',
    dateFrom: DateTime.now(),
    dateTo: DateTime.now(),
    description: '',
    authorId: '',
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
    final firstDate = exactDate.subtract(
      Duration(days: 3650),
    );
    final convertedDate = convertToDate(controller.text) ?? exactDate;
    showDatePicker(
      context: context,
      initialDate:
          convertedDate.isBefore(firstDate) ? firstDate : convertedDate,
      firstDate: firstDate,
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

  void _saveForm(String residentAssociationId) async {
    var isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
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
      try {
        await Provider.of<NotificationsProvider>(context, listen: false)
            .addNotification(
                residentAssociationId,
                NotificationModel(
                  id: null,
                  title: _construction.title,
                  description: _construction.description,
                  date: DateTime.now(),
                  authorId: _construction.authorId,
                  type: Constants.ADDED_CONSTRUCTION,
                ));
      } catch (error) {}
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
                },
              )
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
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Titill...',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Fylla þarf út titil framkvæmdar!';
                          }
                          if (value.length > 40) {
                            return 'Titill framkvæmdar getur ekki verið meira en 40 stafir á lengd!';
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
                            authorId: _construction.authorId != ''
                                ? _construction.authorId
                                : userId,
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
                                return 'Fylla þarf út upphafsdagsetningu framkvæmdar!';
                              }
                              if (_dateToController.text.isNotEmpty) {
                                if (convertToDate(value).isAfter(
                                    convertToDate(_dateToController.text))) {
                                  return 'Valin dagsetning á sér stað á eftir lokadagsetningu framkvæmdar!';
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
                                authorId: _construction.authorId,
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
                                return 'Fylla þarf út lokadagsetningu framkvæmdar!';
                              }
                              if (_dateFromController.text.isNotEmpty) {
                                if (convertToDate(value).isBefore(
                                    convertToDate(_dateFromController.text))) {
                                  return 'Valin dagsetning á sér stað á undan upphafsdagsetningu framkvæmdar!';
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
                                authorId: _construction.authorId,
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
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Nánari lýsing (valfrjálst)...',
                        ),
                        keyboardType: TextInputType.text,
                        onSaved: (value) {
                          _construction = Construction(
                            id: _construction.id,
                            title: _construction.title,
                            dateFrom: _construction.dateFrom,
                            dateTo: _construction.dateTo,
                            description: value,
                            authorId: _construction.authorId,
                          );
                        },
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
