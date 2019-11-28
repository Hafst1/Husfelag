import 'package:flutter/material.dart';

class Document extends StatelessWidget {
  final String title;
  final String description;
  final String folderId;

  Document(
      {@required this.title,
      @required this.description,
      @required this.folderId});


  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      margin: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 3,
      ),
      elevation: 5,
      child: ListTile(
        leading: Icon(Icons.file_download),
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
          //description,
          style: TextStyle(
            decoration: TextDecoration.underline,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
        ),
      ),
    );
  }
}