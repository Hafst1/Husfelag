import 'package:flutter/material.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:husfelagid/models/cleaning_task.dart';
import 'package:husfelagid/providers/cleaning_provider.dart';
import 'package:husfelagid/screens/cleaning/add_cleaningTask_screen.dart';
import 'package:provider/provider.dart';
import '../widgets/action_dialog.dart';
import 'custom_icons_icons.dart';

class CleaningTaskItem extends StatefulWidget {
  final String id;
  final String title;
  final String description;
  final bool taskDone;

  CleaningTaskItem({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.taskDone,
  });

  @override
  _CleaningTaskItemState createState() => _CleaningTaskItemState();
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
    return Card(
        margin: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 5,
        ),
        elevation: 5,
        child: ListTile(
          contentPadding: EdgeInsets.all(10),
          leading: CircularCheckBox(
            value: widget.taskDone,
            materialTapTargetSize: MaterialTapTargetSize.padded,
            onChanged: (check) {
              setState(() {
                _cleaningTask = CleaningTask(
                  id: widget.id,
                  title: widget.title,
                  description: widget.description,
                  taskDone: check,
                );
                Provider.of<CleaningProvider>(context)
                    .updateCleaningTaskItem(_cleaningTask.id, _cleaningTask);
              });
            },
          ),
          title: Text(
            widget.title,
            style: Theme.of(context).textTheme.title,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    widget.description,
                    style:
                        TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
          trailing: IconButton(
              icon: Icon(CustomIcons.dot_3),
              color: Colors.grey,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext ctx) {
                    return ActionDialog(
                      deleteFunc: () {
                        Provider.of<CleaningProvider>(context, listen: false)
                            .deleteCleaningTaskItem(_cleaningTask.id);
                      },
                      editFunc: () {
                        Navigator.of(ctx).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddCleaningTaskScreen(),
                            settings:
                                RouteSettings(arguments: _cleaningTask.id),
                          ),
                        );
                      },
                    );
                  },
                );
              }
              ),
        ));
  }
}
