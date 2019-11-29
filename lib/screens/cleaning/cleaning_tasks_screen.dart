import 'package:flutter/material.dart';
import 'package:husfelagid/providers/cleaning_provider.dart';
import 'package:provider/provider.dart';
import '../../widgets/cleaning_task_item.dart';

class CleaningTasksScreen extends StatefulWidget {
  static const routeName = '/cleaning-tasks';

  @override
  _CleaningTasksScreenState createState() => 
    _CleaningTasksScreenState();
  }

class _CleaningTasksScreenState extends State<CleaningTasksScreen> {
  var _isInit = true;
  var _isLoading = false;

    void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<CleaningProvider>(context)
          .fetchCleaningTasks(context)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = AppBar(
      title: Text("Verkefnalisti"),
    );
    final cleaningTaskData = Provider.of<CleaningProvider>(context);
    final cleaningTasks = cleaningTaskData.getAllTasks();    
    return Scaffold(
      appBar: appBar,
      body: 
      Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: cleaningTasks.length,
              itemBuilder: (ctx, i) => CleaningTaskItem(
                  id: cleaningTasks[i].id,
                  title: cleaningTasks[i].title,
                  description: cleaningTasks[i].description,
                  taskDone: cleaningTasks[i].taskDone,
            )
          )
          )
        ],
      
      )
    );
  }
}
