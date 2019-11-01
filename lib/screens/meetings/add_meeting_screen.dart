import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/meeting.dart';
import '../../widgets/custom_icons_icons.dart';

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
    showDatePicker(
      context: context,
      initialDate: convertToDate(controller.text) ?? exactDate,
      firstDate: DateTime(exactDate.year, exactDate.month, exactDate.day),
      lastDate: DateTime(2100),
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

  void _presentTimePicker(TextEditingController controller) {
    showTimePicker(
      context: context,
      initialTime: convertToTimeOfDay(controller.text) ?? TimeOfDay.now(),
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

  TimeOfDay convertToTimeOfDay(String input) {
    if (input.isEmpty) {
      return null;
    }
    return TimeOfDay(
        hour: int.parse(input.split(':')[0]),
        minute: int.parse(input.split(':')[1]));
  }

  bool isInvalidTime(TimeOfDay startOfMeeting, TimeOfDay endOfMeeting) {
    return DateTime(startOfMeeting.hour, startOfMeeting.minute).isAfter(
      DateTime(endOfMeeting.hour, endOfMeeting.minute),
    );
  }

  void _saveForm() {
    var isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    //_form.currentState.save();
    // Provider.of<ConstructionsProvider>(context, listen: false)
    //     .addConstruction(_newConstruction);
    // Navigator.of(context).pop();
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
                return null;
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
                            TimeOfDay startOfMeeting =
                                convertToTimeOfDay(value);
                            TimeOfDay endOfMeeting =
                                convertToTimeOfDay(_timeToController.text);
                            if (isInvalidTime(
                              startOfMeeting,
                              endOfMeeting,
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
                            TimeOfDay startOfMeeting =
                                convertToTimeOfDay(_timeFromController.text);
                            TimeOfDay endOfMeeting = convertToTimeOfDay(value);
                            if (isInvalidTime(
                              startOfMeeting,
                              endOfMeeting,
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
                return null;
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
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _saveForm();
                  },
                  child: Container(
                    height: 50,
                    width: 120,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      border: Border.all(color: Colors.green[300]),
                    ),
                    child: Text(
                      "BÆTA VIÐ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
