import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/meetings_provider.dart';
import '../../shared/constants.dart' as Constants;

class MeetingDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final meetingId = ModalRoute.of(context).settings.arguments as String;
    final meeting = Provider.of<MeetingsProvider>(context, listen: false)
        .findById(meetingId);
    return Scaffold(
      appBar: AppBar(
        title: Text(meeting.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              width: double.infinity,
              child: Image.asset(
                'assets/images/google_sprint.jpg',
                fit: BoxFit.cover,
                alignment: Alignment.lerp(
                  Alignment.center,
                  Alignment.topCenter,
                  0.33,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 35,
                right: 35,
                top: 30,
                bottom: 15,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.date_range, size: 30),
                      SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          '${Constants.weekdays[meeting.date.weekday - 1]}, ${meeting.date.day}. ${Constants.months[meeting.date.month - 1].toLowerCase()} ${meeting.date.year}',
                          style: TextStyle(fontSize: 17),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Icon(Icons.access_time, size: 30),
                      SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          '${DateFormat.Hm().format(meeting.date)}  -  ${DateFormat.Hm().format(meeting.date.add(meeting.duration))}',
                          style: TextStyle(fontSize: 17),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Icon(Icons.location_on, size: 30),
                      SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          meeting.location,
                          style: TextStyle(fontSize: 17),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
              thickness: 1.5,
              indent: 20,
              endIndent: 20,
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 30,
                right: 30,
                top: 25,
                bottom: 25,
              ),
              width: double.infinity,
              child: meeting.description.isNotEmpty
                  ? Column(
                      children: <Widget>[
                        Text(
                          "Nánari lýsing:",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          meeting.description,
                          style: TextStyle(
                            fontSize: 17,
                            height: 1.75,
                          ),
                          textAlign: TextAlign.justify,
                          softWrap: true,
                        ),
                      ],
                    )
                  : Text(
                      "Engar nánari upplýsingar.",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.center,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
