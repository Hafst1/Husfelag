import 'package:flutter/material.dart';

import '../models/cleaning_task.dart';

class CleaningTaskProvider with ChangeNotifier {
  List<CleaningTask> _dummyData = [
    CleaningTask(
      id: "firebasekey1",
      title: "Ryksuga stigagang",
      description: "Ryksuga þarf allar hæðir",
      taskDone: false,
    ),
    CleaningTask(
      id: "firebasekey2",
      title: "Skúra flísar",
      description: "Skúra flísar með sápu og muna ganga frá skúringardóti inní geymslu",
      taskDone: true,
    ),
    CleaningTask(
      id: "firebasekey3",
      title: "Þurrka af",
      description: "Þurka af gluggakistum og handriði",
      taskDone: false,
    ),
  ];

  List<CleaningTask> get items {
    return [..._dummyData];
  }
  
  List<CleaningTask> getAllTasks() {
    return [..._dummyData];

  }
  
  void updateCleaningTask(String id, CleaningTask editedCleaningTask) {
    final cleaningTaskIndex = _dummyData.indexWhere((cleaningTask) => cleaningTask.id == id);
    _dummyData[cleaningTaskIndex] = editedCleaningTask;
    notifyListeners();
  }

   CleaningTask findById(String id) {
    return _dummyData.firstWhere((cleaningTask) => cleaningTask.id == id);
  } 
}

