import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/cleaning_task_item.dart';
import '../../providers/cleaning_task_provider.dart';

class CleaningTasksScreen extends StatefulWidget {
  static const routeName = '/cleaning-tasks';

  @override
  _CleaningTasksScreenState createState() => 
    _CleaningTasksScreenState();
  }

class _CleaningTasksScreenState extends State<CleaningTasksScreen> {
 
  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = AppBar(
      title: Text("Verkefnalisti"),
    );
    final cleaningTaskData = Provider.of<CleaningTaskProvider>(context);
    final cleaningTasks = cleaningTaskData.getAllTasks();    
    return Scaffold(
      appBar: appBar,
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: cleaningTasks.length,
              itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                value: cleaningTasks[i],
                child: CleaningTaskItem()
              )
            )
          )
        ],
      )
      );
  }
}
