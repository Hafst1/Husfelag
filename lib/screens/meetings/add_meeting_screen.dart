import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../models/meeting.dart';
import '../../providers/meetings_provider.dart';
import '../../widgets/custom_icons_icons.dart';
import '../../widgets/save_button.dart';

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
  var _newMeeting = Meeting(
    id: null,
    title: '',
    date: DateTime.now(),
    duration: Duration(),
    location: '',
    description: '',
  );

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

  void _saveForm() {
    var isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    Provider.of<MeetingsProvider>(context, listen: false)
        .addMeeting(_newMeeting);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bóka fund"),
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
                hintText: "Titill...",
                prefixIcon: Icon(CustomIcons.pencil),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return "Titill fundar getur ekki verið tómur strengur!";
                }
                if (value.length > 40) {
                  return "Titill fundar getur ekki verið meira en 40 stafir á lengd!";
                }
                return null;
              },
              onSaved: (value) {
                _newMeeting = Meeting(
                  id: _newMeeting.id,
                  title: value,
                  date: _newMeeting.date,
                  duration: _newMeeting.duration,
                  location: _newMeeting.location,
                  description: _newMeeting.description,
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
                    _newMeeting = Meeting(
                      id: _newMeeting.id,
                      title: _newMeeting.title,
                      date: DateTime(
                        chosenDate.year,
                        chosenDate.month,
                        chosenDate.day,
                        chosenStartTime.hour,
                        chosenStartTime.minute,
                      ),
                      duration: _newMeeting.duration,
                      location: _newMeeting.location,
                      description: _newMeeting.description,
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
                    onTap: () => _presentTimePicker(_timeFromController),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _timeFromController,
                        decoration: InputDecoration(
                          hintText: "Frá...",
                          prefixText:
                              _timeFromController.text != "" ? "Frá: " : "",
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
                          prefixText:
                              _timeToController.text != "" ? "Til: " : "",
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
                          _newMeeting = Meeting(
                            id: _newMeeting.id,
                            title: _newMeeting.title,
                            date: _newMeeting.date,
                            duration:
                                _getDuration(_timeFromController.text, value),
                            location: _newMeeting.location,
                            description: _newMeeting.description,
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
              decoration: InputDecoration(
                hintText: "Staðsetning...",
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return "Staðsetning fundar getur ekki verið tómur strengur!";
                }
                if (value.length > 40) {
                  return "Staðsetning fundar getur ekki verið meira en 40 stafir á lengd!";
                }
                return null;
              },
              onSaved: (value) {
                _newMeeting = Meeting(
                  id: _newMeeting.id,
                  title: _newMeeting.title,
                  date: _newMeeting.date,
                  duration: _newMeeting.duration,
                  location: value,
                  description: _newMeeting.description,
                );
              },
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
                  return "Lýsing fundar þarf að vera a.m.k. 10 stafir á lengd!";
                }
                return null;
              },
              onSaved: (value) {
                _newMeeting = Meeting(
                  id: _newMeeting.id,
                  title: _newMeeting.title,
                  date: _newMeeting.date,
                  duration: _newMeeting.duration,
                  location: _newMeeting.location,
                  description: value,
                );
              },
            ),
            SizedBox(
              height: 15,
            ),
            SaveButton(
              saveFunc: _saveForm,
            )
          ]),
        ),
      ),
    );
  }
}
