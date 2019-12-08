import 'package:flutter/material.dart';

import './custom_icons_icons.dart';

class ActionDialog extends StatelessWidget {
  final Function deleteFunc;
  final Function editFunc;

  ActionDialog({
    @required this.deleteFunc,
    @required this.editFunc,
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
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.of(context).pop();
                  showDialog(
                      context: context,
                      builder: (BuildContext ctx) {
                        return AlertDialog(
                          title: Text(
                              "Ertu viss um að þú viljir eyða þessari færslu?"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                "HÆTTA VIÐ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                            ),
                            FlatButton(
                                child: Text(
                                  "EYÐA",
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                  deleteFunc();
                                }),
                          ],
                        );
                      });
                },
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Icon(
                        Icons.delete,
                        size: 50,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      "EYÐA",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => editFunc(),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Icon(
                        CustomIcons.pencil,
                        size: 50,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "BREYTA",
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
