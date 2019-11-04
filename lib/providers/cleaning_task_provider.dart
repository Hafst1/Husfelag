import 'package:flutter/material.dart';

import '../models/cleaning_task.dart';

class CleaningTaskProvider with ChangeNotifier {
  List<CleaningTask> _dummyData = [
    CleaningTask(
      id: "firebasekey1",
      title: "Ryksuga stigagang",
      description: "",
    ),
    CleaningTask(
      id: "firebasekey2",
      title: "Skúra flísar",
      description: "",
    ),
    CleaningTask(
      id: "firebasekey3",
      title: "Þurrka af",
      description: "",
    ),
  ];

  List<CleaningTask> get items {
    return [..._dummyData];
  }

  List<CleaningTask> getAllTasks() {
   /* List<CleaningTask> cleaningTasks = [..._dummyData];
    print("cleaningtask");
    print(cleaningTasks);

    return cleaningTasks;*/
    return [..._dummyData];

  }

/*
  List<CleaningTask> filteredItems(String query, int filterIndex) {
    List<CleaningTask> cleaningTasks = [..._dummyData];
    String searchQuery = query.toLowerCase();
    List<CleaningTask> displayList = [];
    if (query.isNotEmpty) {
      cleaningTasks.forEach((item) {
        if (item.title.toLowerCase().contains(searchQuery))
      }
      
    }
  }
  */
}

