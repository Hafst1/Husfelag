import 'package:flutter/material.dart';

import '../widgets/custom_icons_icons.dart';

class UserListItem extends StatefulWidget {
  final ValueKey key;
  final String userId;
  final String title;
  final String apartmentNumber;
  final IconData iconData;
  final Function makeAdminFunc;
  final Function kickUserFunc;
  final bool viewerIsAdmin;
  final bool targetIsAdmin;

  UserListItem({
    this.key,
    @required this.userId,
    @required this.title,
    @required this.apartmentNumber,
    @required this.iconData,
    @required this.makeAdminFunc,
    @required this.kickUserFunc,
    @required this.viewerIsAdmin,
    @required this.targetIsAdmin,
  });

  @override
  _UserListItemState createState() => _UserListItemState();
}

class _UserListItemState extends State<UserListItem> {
  var _isPushed = false;

  // function which presents the buttons to promote a user to
  // admin or kick him out of the resident association.
  _presentOptions() {
    setState(() {
      _isPushed = !_isPushed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      elevation: 5,
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: _presentOptions,
            contentPadding: EdgeInsets.all(15),
            leading: Padding(
              padding: EdgeInsets.all(10),
              child: Icon(
                widget.iconData,
                size: 50,
                color: Colors.grey[600],
              ),
            ),
            title: Text(
              widget.title,
              style: Theme.of(context).textTheme.title,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.home),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Íbúð ' + widget.apartmentNumber,
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  widget.targetIsAdmin
                      ? Expanded(
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 25,
                              ),
                              Icon(
                                Icons.settings,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Admin',
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
          _isPushed
              ? (widget.viewerIsAdmin && !widget.targetIsAdmin)
                  ? Column(
                      children: <Widget>[
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                          indent: 5,
                          endIndent: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 8.0,
                            top: 8.0,
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(),
                              ),
                              FlatButton(
                                onPressed: () =>
                                    widget.makeAdminFunc(widget.userId),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.settings,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Veita admin réttindi',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                color: Colors.green[200],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.green[200]),
                                ),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              FlatButton(
                                onPressed: () {
                                  widget.kickUserFunc(
                                    widget.userId,
                                    widget.apartmentNumber,
                                  );
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      CustomIcons.user_times,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      'Sparka úr húsfélagi',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                color: Colors.red[200],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.red[200]),
                                ),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Container()
              : Container(),
        ],
      ),
    );
  }
}
