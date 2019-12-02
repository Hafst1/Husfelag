import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../models/meeting.dart';
import '../../providers/meetings_provider.dart';
import '../../providers/current_user_provider.dart';
import '../../widgets/custom_icons_icons.dart';
import '../../widgets/save_button.dart';
import '../../shared/loading_spinner.dart';

class AddMeetingScreen extends StatefulWidget {
  static const routeName = '/add-meeting';

  @override
  _AddMeetingScreenState createState() => _AddMeetingScreenState();
}

class _AddMeetingScreenState extends State<AddMeetingScreen> {
  final _dateController = TextEditingController();
  final _timeFromController = TextEditingController();
  final _timeToController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _meeting = Meeting(
    id: null,
    title: '',
    date: DateTime.now(),
    duration: Duration(),
    location: '',
    description: '',
  );
  var _initValues = {
    'appbar-title': 'Bóka fund',
    'title': '',
    'location': '',
    'description': '',
    'save-text': 'BÓKA',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final meetingId = ModalRoute.of(context).settings.arguments as String;
      if (meetingId != null) {
        _meeting = Provider.of<MeetingsProvider>(context, listen: false)
            .findById(meetingId);
        _initValues = {
          'appbar-title': 'Breyta fundi',
          'title': _meeting.title,
          'location': _meeting.location,
          'description': _meeting.description,
          'save-text': 'BREYTA',
        };
        _dateController.text = DateFormat.yMMMMEEEEd().format(_meeting.date);
        DateTime timeToValue = _meeting.date.add(_meeting.duration);
        _timeFromController.text =
            '${_meeting.date.hour.toString().padLeft(2, '0')}:${_meeting.date.minute.toString().padLeft(2, '0')}';
        _timeToController.text =
            '${timeToValue.hour.toString().padLeft(2, '0')}:${timeToValue.minute.toString().padLeft(2, '0')}';
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeFromController.dispose();
    _timeToController.dispose();
    super.dispose();
  }

  void _presentDatePicker(TextEditingController controller) {
    DateTime exactDate = DateTime.now();
    DateTime startOfCurrentDate =
        DateTime(exactDate.year, exactDate.month, exactDate.day);
    showDatePicker(
      context: context,
      initialDate: _convertToDate(controller.text) ?? startOfCurrentDate,
      firstDate: startOfCurrentDate,
      lastDate: startOfCurrentDate.add(
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

  DateTime _convertToDate(String input) {
    try {
      var d = new DateFormat.yMMMMEEEEd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  void _presentTimePicker(TextEditingController controller) {
    showTimePicker(
      context: context,
      initialTime: _convertToTimeOfDay(controller.text) ?? TimeOfDay.now(),
    ).then((pickedTime) {
      if (pickedTime == null) {
        return;
      }
      setState(() {
        controller.text =
            '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
      });
    });
  }

  TimeOfDay _convertToTimeOfDay(String input) {
    if (input.isEmpty) {
      return null;
    }
    return TimeOfDay(
        hour: int.parse(input.split(':')[0]),
        minute: int.parse(input.split(':')[1]));
  }

  bool _isInvalidTime(String startingTime, String endingTime) {
    DateTime currentDate = DateTime.now();
    TimeOfDay startOfMeeting = _convertToTimeOfDay(startingTime);
    TimeOfDay endOfMeeting = _convertToTimeOfDay(endingTime);

    return DateTime(currentDate.year, currentDate.month, currentDate.day,
            startOfMeeting.hour, startOfMeeting.minute)
        .isAfter(
      DateTime(currentDate.year, currentDate.month, currentDate.day,
          endOfMeeting.hour, endOfMeeting.minute),
    );
  }

  Duration _getDuration(String startingTime, String endingTime) {
    DateTime currentDate = DateTime.now();
    TimeOfDay startOfMeeting = _convertToTimeOfDay(startingTime);
    TimeOfDay endOfMeeting = _convertToTimeOfDay(endingTime);

    return DateTime(currentDate.year, currentDate.month, currentDate.day,
            endOfMeeting.hour, endOfMeeting.minute)
        .difference(
      DateTime(currentDate.year, currentDate.month, currentDate.day,
          startOfMeeting.hour, startOfMeeting.minute),
    );
  }

  Future<void> _saveForm() async {
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
            .getResidentAssociationNumber();
    if (_meeting.id != null) {
      try {
        await Provider.of<MeetingsProvider>(context, listen: false)
            .updateMeeting(residentAssociationId, _meeting);
      } catch (error) {
        await printErrorDialog('Ekki tókst að breyta fundi!');
      }
    } else {
      try {
        await Provider.of<MeetingsProvider>(context, listen: false)
            .addMeeting(residentAssociationId, _meeting);
      } catch (error) {
        await printErrorDialog('Ekki tókst að bæta við fundi!');
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
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _saveForm();
              }),
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
                          return "Fylla þarf út titil fundar!";
                        }
                        if (value.length > 40) {
                          return "Titill fundar getur ekki verið meira en 40 stafir á lengd!";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _meeting = Meeting(
                          id: _meeting.id,
                          title: value,
                          date: _meeting.date,
                          duration: _meeting.duration,
                          location: _meeting.location,
                          description: _meeting.description,
                        );
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () => _presentDatePicker(_dateController),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _dateController,
                          decoration: InputDecoration(
                            hintText: "Dagsetning...",
                            prefixIcon: Icon(Icons.date_range),
                            border: OutlineInputBorder(),
                            errorMaxLines: 2,
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Útvega þarf dagsetningu fundar!";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            DateTime chosenDate = _convertToDate(value);
                            TimeOfDay chosenStartTime =
                                _convertToTimeOfDay(_timeFromController.text);
                            _meeting = Meeting(
                              id: _meeting.id,
                              title: _meeting.title,
                              date: DateTime(
                                chosenDate.year,
                                chosenDate.month,
                                chosenDate.day,
                                chosenStartTime.hour,
                                chosenStartTime.minute,
                              ),
                              duration: _meeting.duration,
                              location: _meeting.location,
                              description: _meeting.description,
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                _presentTimePicker(_timeFromController),
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: _timeFromController,
                                decoration: InputDecoration(
                                  hintText: "Frá...",
                                  prefixText: _timeFromController.text != ""
                                      ? "Frá: "
                                      : "",
                                  prefixIcon: Icon(Icons.access_time),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Útvega þarf tímasetningu!";
                                  }
                                  if (_timeToController.text.isNotEmpty) {
                                    if (_isInvalidTime(
                                      value,
                                      _timeToController.text,
                                    )) {
                                      return "Ógild tímasetning!";
                                    }
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _presentTimePicker(_timeToController),
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: _timeToController,
                                decoration: InputDecoration(
                                  hintText: "Til...",
                                  prefixText: _timeToController.text != ""
                                      ? "Til: "
                                      : "",
                                  prefixIcon: Icon(Icons.access_time),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Útvega þarf tímasetningu!";
                                  }
                                  if (_timeFromController.text.isNotEmpty) {
                                    if (_isInvalidTime(
                                      _timeFromController.text,
                                      value,
                                    )) {
                                      return "Ógild tímasetning!";
                                    }
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _meeting = Meeting(
                                    id: _meeting.id,
                                    title: _meeting.title,
                                    date: _meeting.date,
                                    duration: _getDuration(
                                        _timeFromController.text, value),
                                    location: _meeting.location,
                                    description: _meeting.description,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      initialValue: _initValues['location'],
                      decoration: InputDecoration(
                        hintText: "Staðsetning...",
                        prefixIcon: Icon(Icons.location_on),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Fylla þarf út staðsetningu fundar!";
                        }
                        if (value.length > 40) {
                          return "Staðsetning fundar getur ekki verið meira en 40 stafir á lengd!";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _meeting = Meeting(
                          id: _meeting.id,
                          title: _meeting.title,
                          date: _meeting.date,
                          duration: _meeting.duration,
                          location: value,
                          description: _meeting.description,
                        );
                      },
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
                        _meeting = Meeting(
                          id: _meeting.id,
                          title: _meeting.title,
                          date: _meeting.date,
                          duration: _meeting.duration,
                          location: _meeting.location,
                          description: value,
                        );
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SaveButton(
                      text: _initValues['save-text'],
                      saveFunc: _saveForm,
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
