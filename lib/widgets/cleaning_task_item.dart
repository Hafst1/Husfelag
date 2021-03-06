import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:circular_check_box/circular_check_box.dart';

import '../models/cleaning_task.dart';
import '../providers/cleaning_provider.dart';
import '../providers/current_user_provider.dart';
import '../screens/cleaning/add_cleaning_task_screen.dart';
import '../widgets/action_dialog.dart';
import 'custom_icons_icons.dart';

class CleaningTaskItem extends StatefulWidget {
  final String id;
  final String title;
  final String description;
  final bool taskDone;
  final bool isAdmin;
  final bool canCheck;

  CleaningTaskItem({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.taskDone,
    @required this.isAdmin,
    @required this.canCheck,
  });

  @override
  _CleaningTaskItemState createState() => _CleaningTaskItemState();
}

class _CleaningTaskItemState extends State<CleaningTaskItem> {
  // function which changes the task status of a cleaning task item.
  _changeTaskStatus(bool value) async {
    final residentAssociationId =
        Provider.of<CurrentUserProvider>(context, listen: false)
            .getResidentAssociationId();
    try {
      await Provider.of<CleaningProvider>(context).updateCleaningTaskItem(
        residentAssociationId,
        CleaningTask(
          id: widget.id,
          title: widget.title,
          taskDone: value,
          description: widget.description,
        ),
      );
    } catch (error) {
      await _printErrorDialog('Ekki tókst að bæta við verkefni!');
    }
  }

  // function which prints an error dialog.
  Future<void> _printErrorDialog(String errorMessage) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Villa kom upp'),
        content: Text(errorMessage),
        actions: <Widget>[
          FlatButton(
            child: Text('Halda áfram'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  // function which presents an error dialog where user can choose to
  // edit or delete cleaning task item.
  _showActionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return ActionDialog(
          deleteFunc: () {
            final residentAssociationId =
                Provider.of<CurrentUserProvider>(context, listen: false)
                    .getResidentAssociationId();
            Provider.of<CleaningProvider>(context, listen: false)
                .deleteCleaningTaskItem(residentAssociationId, widget.id);
          },
          editFunc: () {
            Navigator.of(ctx).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddCleaningTaskScreen(),
                settings: RouteSettings(arguments: widget.id),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      elevation: 5,
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: widget.canCheck
            ? CircularCheckBox(
                value: widget.taskDone,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                onChanged: (value) => _changeTaskStatus(value),
              )
            : Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 8,
                  bottom: 5,
                  top: 13,
                ),
                child: FittedBox(
                  child: Icon(
                    CustomIcons.circle,
                    color: Colors.grey,
                    size: 18,
                  ),
                ),
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
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
        trailing: widget.isAdmin
            ? IconButton(
                icon: Icon(CustomIcons.dot_3),
                color: Colors.grey,
                onPressed: () => _showActionDialog(context),
              )
            : Icon(
                Icons.question_answer,
                color: Colors.white,
              ),
      ),
    );
  }
}
