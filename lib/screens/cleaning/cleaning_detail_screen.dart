import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/detail_date_item.dart';
import '../../providers/cleaning_provider.dart';
import '../../models/cleaning_task.dart';
import '../../widgets/custom_icons_icons.dart';

class CleaningDetailScreen extends StatelessWidget {
  final List<CleaningTask> tasks = [
    CleaningTask(
      id: "firebasekey1",
      title: "Ryksuga stigagang",
      description: "Ryksuga þarf allar hæðir",
    ),
    CleaningTask(
      id: "firebasekey2",
      title: "Skúra flísar",
      description:
          "Skúra flísar með sápu og muna ganga frá skúringardóti inní geymslu",
    ),
    CleaningTask(
      id: "firebasekey3",
      title: "Þurrka af",
      description: "Þurka af gluggakistum og handriði",
    ),
    CleaningTask(
      id: "firebasekey1",
      title: "Ryksuga stigagang",
      description: "Ryksuga þarf allar hæðir",
    ),
    CleaningTask(
      id: "firebasekey2",
      title: "Skúra flísar",
      description:
          "Skúra flísar með sápu og muna ganga frá skúringardóti inní geymslu",
    ),
    CleaningTask(
      id: "firebasekey3",
      title: "Þurrka af",
      description: "Þurka af gluggakistum og handriði",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cleaningId = ModalRoute.of(context).settings.arguments as String;
    final cleaning =
        Provider.of<CleaningProvider>(context, listen: false).findById(cleaningId);
    return Scaffold(
      appBar: AppBar(
        title: Text("Þrif á sameign"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                left: 35,
                right: 35,
                top: 30,
                bottom: 25,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    Icons.home,
                    size: 40,
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      cleaning.apartment,
                      style: TextStyle(fontSize: 25),
                      overflow: TextOverflow.ellipsis,
                    ),
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
                top: 15,
                bottom: 15,
              ),
              child: Column(
                children: <Widget>[
                  DetailDateItem(
                    text: "Frá:",
                    date: cleaning.dateFrom,
                  ),
                  SizedBox(height: 10),
                  DetailDateItem(
                    text: "Til:",
                    date: cleaning.dateTo,
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
              child: tasks.isNotEmpty
                  ? Column(
                      children: <Widget>[
                        Text(
                          "Verkefnalisti:",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        ...tasks
                            .map((task) => Container(
                                  margin: EdgeInsets.only(bottom: 15),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(
                                        Icons.check_circle_outline,
                                        size: 30,
                                        color: Colors.purple,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Text(
                                          task.title,
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ],
                    )
                  : Column(
                      children: <Widget>[
                        Text(
                          "Verkefnalisti yfir þrif á sameign er tómur.",
                          style: TextStyle(
                            fontSize: 17,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          child: FittedBox(
                            child: Icon(CustomIcons.smile),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
