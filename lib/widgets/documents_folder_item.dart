import 'package:flutter/material.dart';
import '../screens/documents/documents_list_screen.dart';

class DocumentFolder extends StatelessWidget {
  final String title;
  final String id;
  final bool isAdmin;
  final bool isAuthor;

  DocumentFolder({
      @required this.title,
      @required this.id,
      @required this.isAdmin,
      @required this.isAuthor,
  });


  @override
  Widget build(BuildContext context) {

    return Card(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DocumentsFolderScreen(id: id),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[600]),
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(15),
          ),
          child: LayoutBuilder(
            builder: (ctx, constraints) {
              return Column(
                children: <Widget>[
                  Container(
                    height: constraints.maxHeight * 0.75,
                    child: Icon(
                      Icons.folder_open,
                      size: constraints.maxHeight * 0.4,
                    ),
                  ),
                  Container(
                    height: constraints.maxHeight * 0.25,
                    padding: EdgeInsets.fromLTRB(
                      constraints.maxWidth * 0.025,
                      constraints.maxHeight * 0.01,
                      constraints.maxWidth * 0.025,
                      constraints.maxHeight * 0.1,
                    ),
                    child: FittedBox(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
