import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/cleaning_task_item.dart';
import '../../providers/cleaning_task_provider.dart';
import '../../providers/CRUDmodel.dart'; 
import './cleaning_tasks_router.dart';

//Renders CleaningTasksListScreen and CRUDmodel
class CleaningTasksScreen extends StatelessWidget {
  static const routeName = '/cleaning-tasks';
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => CRUDModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/cleaning-tasks-list',
        title: 'Product App',
        theme: ThemeData(),
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}




/*
class CleaningTasksScreen extends StatefulWidget {
  static const routeName = '/cleaning-tasks';

  @override
  _CleaningTasksScreenState createState() => 
    _CleaningTasksScreenState();
  }

class _CleaningTasksScreenState extends State<CleaningTasksScreen> {
  
  @override
  Widget build(BuildContext context) {
   // final mediaQuery = MediaQuery.of(context);
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
              itemBuilder: (ctx, i) => CleaningTaskItem(
                title: cleaningTasks[i].title,
                description: cleaningTasks[i].description,
              )
            )
          )
        ],
      )
      );
  }
}
*/