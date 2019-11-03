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
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = AppBar(
      title: Text("Verkefnalisti"),
    );
    final heightOfBody = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height -
        kBottomNavigationBarHeight;
    final cleaningTaskData = Provider.of<CleaningTaskProvider>(context);
    final cleaningTasks = cleaningTaskData.getAllTasks();

    return Scaffold(
      appBar: appBar,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: heightOfBody * 0.23,
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  bottom: 10,
                ),
                child: ListView.builder(
                  itemCount: cleaningTasks.length,
                  itemBuilder: (ctx, i) => CleaningTaskItem(
                  title: cleaningTasks[i].title,
                  description: cleaningTasks[i].description,
                  route: "some route",
                ) 
                )
                    )
                  ],
                )
              )
          )
        
          
         /* ListView.builder(
          itemCount: cleaningTasks.length,
          itemBuilder: (ctx, i) => CleaningTaskItem(
            title: cleaningTasks[i].title,
            description: cleaningTasks[i].description,
          ) 
        ) */
      );
  }
}
