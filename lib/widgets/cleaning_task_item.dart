import 'package:flutter/material.dart';
import 'package:circular_check_box/circular_check_box.dart';

  class CleaningTaskItem extends StatefulWidget {
    final String id;
    final String title;
    final String description;

    const CleaningTaskItem({Key key, this.id, this.title, this.description}):
    super(key: key);

    @override
    _CleaningTaskItemState createState() => 
      _CleaningTaskItemState();
  }

  class _CleaningTaskItemState extends State<CleaningTaskItem> {
  bool check = false; 
  void valueChanged(bool value) => setState(() => check = value);

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
                    style: TextStyle(fontSize: 15/*, color: Colors.grey[700]*/),
                  ),
                ),
              ],
            ),
          ),
          trailing: CircularCheckBox(
            value: check,
            materialTapTargetSize: MaterialTapTargetSize.padded,
            onChanged: valueChanged,
            activeColor: Colors.red[200],
          ),
      )
    );
  }
}

