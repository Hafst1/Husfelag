import 'package:flutter/material.dart';

import './custom_icons_icons.dart';

class AddDialog extends StatelessWidget {
  final Function addFolderFunc;
  final Function addFileFunc;

  AddDialog({
    @required this.addFolderFunc,
    @required this.addFileFunc,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  addFolderFunc();
                },
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Icon(
                        Icons.folder_open,
                        size: 60,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Ný mappa",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => addFileFunc(),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Icon(
                        CustomIcons.file_add,
                        size: 50,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Nýtt skjal",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}