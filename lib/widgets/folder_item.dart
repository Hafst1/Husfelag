import 'package:flutter/material.dart';
import '../screens/documents/documents_list_screen.dart';

class FolderItem extends StatelessWidget {
  final String title;
  final String id;
  final bool isAdmin;

  FolderItem({
    @required this.title,
    @required this.id,
    @required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DocumentsListScreen(),
            settings: RouteSettings(arguments: id),
          ),
        );
      },
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          return Column(
            children: <Widget>[
              Container(
                height: constraints.maxHeight * 0.75,
                child: Icon(
                  Icons.folder,
                  // color: Color.fromRGBO(244, 217, 132, 1), // yellow
                  color: Color.fromRGBO(236, 202, 165, 1), // little browner
                  // color: Color.fromRGBO(231, 190, 142, 1),
                  size: constraints.maxHeight * 0.75,
                ),
              ),
              Container(
                height: constraints.maxHeight * 0.25,
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.title.copyWith(
                        fontSize: 15,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
