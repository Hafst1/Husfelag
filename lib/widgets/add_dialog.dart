import 'package:flutter/material.dart';

import './custom_icons_icons.dart';

class AddDialog extends StatelessWidget {
  final Function addFolderFunc;
  final Function addFileFunc;
  final bool atLeastOneFolder;

  AddDialog({
    @required this.addFolderFunc,
    @required this.addFileFunc,
    @required this.atLeastOneFolder,
  });

  @override
  Widget build(BuildContext context) {
    return atLeastOneFolder
        ? AlertDialog(
            content: Container(
              height: 100,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => addFolderFunc(),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Icon(
                              Icons.folder_open,
                              size: 65,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "NÝ MAPPA",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
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
                            "NÝTT SKJAL",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 80,
            ),
            child: AlertDialog(
              content: Container(
                height: 100,
                width: 50,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => addFolderFunc(),
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Icon(
                                Icons.folder_open,
                                size: 65,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "NÝ MAPPA",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
