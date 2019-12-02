import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cleaning_provider.dart';
import '../../providers/current_user_provider.dart';
import '../../widgets/cleaning_task_item.dart';
import 'add_cleaningTask_screen.dart';
import '../../shared/loading_spinner.dart';

class CleaningTasksScreen extends StatefulWidget {
  static const routeName = '/cleaning-tasks';

  @override
  _CleaningTasksScreenState createState() => _CleaningTasksScreenState();
}

class _CleaningTasksScreenState extends State<CleaningTasksScreen> {
  var _isInit = true;
  var _isLoading = false;

  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final residentAssociationId =
          Provider.of<CurrentUserProvider>(context, listen: false)
              .getResidentAssociationId();
      Provider.of<CleaningProvider>(context)
          .fetchCleaningTasks(residentAssociationId, context)
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
    final cleaningTaskData = Provider.of<CleaningProvider>(context);
    final cleaningTasks = cleaningTaskData.getAllTasks();
    return Scaffold(
      appBar: AppBar(
        title: Text('Verkefnalisti'),
        centerTitle: true,
      ),
      body: _isLoading
          ? LoadingSpinner()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Card(
                  margin: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 5,
                  ),
                  child: MaterialButton(
                    color: Colors.white,
                    textColor: Colors.lightBlueAccent,
                    padding: EdgeInsets.all(20.0),
                    child: Text("Bæta við verkefni"),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddCleaningTaskScreen(),
                      ));
                    },
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: cleaningTasks.length,
                        itemBuilder: (ctx, i) => CleaningTaskItem(
                              id: cleaningTasks[i].id,
                              title: cleaningTasks[i].title,
                              description: cleaningTasks[i].description,
                              taskDone: cleaningTasks[i].taskDone,
                            ))),
              ],
            ),
    );
  }
}
