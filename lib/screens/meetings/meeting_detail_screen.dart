import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/meetings_provider.dart';
import '../../constants/constants.dart' as Constants;

class MeetingDetailScreen extends StatelessWidget {
  final String id;

  MeetingDetailScreen({@required this.id});

  @override
  Widget build(BuildContext context) {
    final meeting =
        Provider.of<MeetingsProvider>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(meeting.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
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
                      Text(
                        '${Constants.weekdays[meeting.date.weekday - 1]}, ${meeting.date.day}. ${Constants.months[meeting.date.month - 1].toLowerCase()} ${meeting.date.year}',
                        style: TextStyle(fontSize: 17),
                        softWrap: true,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Icon(Icons.access_time, size: 30),
                      SizedBox(width: 15),
                      Text(
                        '${DateFormat.Hm().format(meeting.date)}  -  ${DateFormat.Hm().format(meeting.date.add(meeting.duration))}',
                        style: TextStyle(fontSize: 17),
                        softWrap: true,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Icon(Icons.location_on, size: 30),
                      SizedBox(width: 15),
                      Text(
                        meeting.location,
                        style: TextStyle(fontSize: 17),
                        softWrap: true,
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
                left: 35,
                right: 35,
                top: 25,
                bottom: 25,
              ),
              width: double.infinity,
              child: Column(
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
              ),
            ),
            // Container(
            //   padding: const EdgeInsets.only(
            //     left: 10,
            //     right: 10,
            //     top: 25,
            //     bottom: 10,
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: <Widget>[
            //       GestureDetector(
            //         child: Container(
            //           height: 50,
            //           width: 120,
            //           alignment: Alignment.center,
            //           decoration: BoxDecoration(
            //             color: Colors.green[300],
            //             //border: Border.all(color: Colors.green[300]),
            //           ),
            //           child: Text(
            //             "MÆTI",
            //             style: TextStyle(
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //         ),
            //       ),
            //       GestureDetector(
            //         child: Container(
            //           height: 50,
            //           width: 120,
            //           alignment: Alignment.center,
            //           decoration: BoxDecoration(
            //             color: Colors.grey[300],
            //             //border: Border.all(color: Colors.grey[600]),
            //           ),
            //           child: Text(
            //             "KANNSKI",
            //             style: TextStyle(
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //         ),
            //       ),
            //       GestureDetector(
            //         child: Container(
            //           height: 50,
            //           width: 120,
            //           alignment: Alignment.center,
            //           decoration: BoxDecoration(
            //             color: Colors.red[200],
            //              //border: Border.all(color: Colors.red[300]),
            //           ),
            //           child: Text(
            //             "KEMST EKKI",
            //             style: TextStyle(
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
