import 'package:flutter/material.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:husfelagid/models/cleaning_task.dart';
import 'package:husfelagid/providers/cleaning_task_provider.dart';
import 'package:provider/provider.dart';

  class CleaningTaskItem extends StatefulWidget {
  
    @override
    _CleaningTaskItemState createState() => 
      _CleaningTaskItemState();
  }

  class _CleaningTaskItemState extends State<CleaningTaskItem> {
    var _cleaningTask = CleaningTask(
      id: null,
      title: '',
      description: '',
      taskDone: false,
    );
 
  @override
  Widget build(BuildContext context) {
    final cleaningTask = Provider.of<CleaningTask>(context);
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      elevation: 5,
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        title: Text(
          cleaningTask.title,
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    cleaningTask.description,
                    style: TextStyle(fontSize: 15/*, color: Colors.grey[700]*/),
                  ),
                ),
              ],
            ),
          ),
          trailing: CircularCheckBox(
            value: cleaningTask.taskDone,
            materialTapTargetSize: MaterialTapTargetSize.padded,
            onChanged: (check) {
              setState(() {
                _cleaningTask = CleaningTask(
                  id: cleaningTask.id,
                  title: cleaningTask.title,
                  description: cleaningTask.description,
                  taskDone: check,
                );
              Provider.of<CleaningTaskProvider>(context)
              .updateCleaningTask(_cleaningTask.id, _cleaningTask);
              });
            },
          ),
      )
    );
  }
}

