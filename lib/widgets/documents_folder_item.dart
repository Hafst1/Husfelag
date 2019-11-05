import 'package:flutter/material.dart';
import '../screens/documents/documents_folder_screen.dart';

class DocumentFolder extends StatelessWidget {
  final String title;
  final String id;

  DocumentFolder(
      {@required this.title,
      @required this.id});


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      elevation: 5,
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DocumentsFolderScreen(id: id),
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
