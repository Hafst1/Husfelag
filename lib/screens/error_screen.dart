import 'package:flutter/material.dart';

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
            print('þú ýttir á takkann');
          },
          child: Text('Reyna aftur'),
        ),
      ],
    )));
  }
}
