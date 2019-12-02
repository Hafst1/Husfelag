import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:circular_check_box/circular_check_box.dart';

import '../models/cleaning_task.dart';
import '../providers/cleaning_provider.dart';
import '../providers/current_user_provider.dart';
import '../screens/cleaning/add_cleaningTask_screen.dart';
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
 
  _changeTaskStatus(bool value) async {
    final residentAssociationId =
        Provider.of<CurrentUserProvider>(context, listen: false)
            .getResidentAssociationNumber();
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

  _showActionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return ActionDialog(
          deleteFunc: () {
            final residentAssociationId =
                Provider.of<CurrentUserProvider>(context, listen: false)
                    .getResidentAssociationNumber();
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
            onChanged: (value) => _changeTaskStatus(value),
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
          trailing: IconButton(
            icon: Icon(CustomIcons.dot_3),
            color: Colors.grey,
            onPressed: () => _showActionDialog(context),
          ),
        ));
  }
}
