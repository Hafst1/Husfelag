import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/current_user_provider.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      children: <Widget>[
        SizedBox(height: 170),
        Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 100,
        ),
        SizedBox(height: 50),
        Text(
          "Eitthvað fór úrskeiðis",
          style: Theme.of(context).textTheme.title,
        ),
        SizedBox(height: 50),
        RaisedButton(
          onPressed: () {
            Provider.of<CurrentUserProvider>(context)
                .triggerCurrentUserRefresh();
          },
          child: Text('Reyna aftur'),
        ),
      ],
    )));
  }
}
