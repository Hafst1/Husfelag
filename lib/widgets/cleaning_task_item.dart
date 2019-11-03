import 'package:flutter/material.dart';

class CleaningTaskItem extends StatelessWidget {
  final String title;
  final String description; 

  CleaningTaskItem(
    {@required this.title,
    @required this.description});

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
          title,
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    description,
                    style: TextStyle(fontSize: 15/*, color: Colors.grey[700]*/),
                  ),
                ),
              ],
            ),
          ),
      )
    );
  }
}

