import 'package:flutter/material.dart';

import '../models/cleaning_task.dart';

class CleaningTaskProvider with ChangeNotifier {
  List<CleaningTask> _dummyData = [
    CleaningTask(
      id: "firebasekey1",
      title: "Ryksuga stigagang",
      description: "Ryksuga þarf allar hæðir",
    ),
    CleaningTask(
      id: "firebasekey2",
      title: "Skúra flísar",
      description: "Skúra flísar með sápu og muna ganga frá skúringardóti inní geymslu",
    ),
    CleaningTask(
      id: "firebasekey3",
      title: "Þurrka af",
      description: "Þurka af gluggakistum og handriði",
    ),
  ];

  List<CleaningTask> get items {
    return [..._dummyData];
  }
  
  List<CleaningTask> getAllTasks() {
    return [..._dummyData];

  }
}

