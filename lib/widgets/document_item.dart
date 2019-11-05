import 'package:flutter/material.dart';

class DocumentItem extends StatelessWidget {
  final String title;
  final String folderId;

  DocumentItem(
      {@required this.title,
      @required this.folderId});


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 3,
      ),
      elevation: 5,
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              //builder: (context) => DocumentScreen(id: id),
            ),
          );
        },
        contentPadding: EdgeInsets.all(10),
        title: Text(
          title,
          style: Theme.of(context).textTheme.title,
        ),
      ),
    );
  }
}