import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  final String text;
  final Function saveFunc;

  SaveButton({
    @required this.text,
    @required this.saveFunc,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FlatButton(
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            saveFunc();
          },
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.green[300])),
          color: Colors.green[200],
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ],
    );
  }
}
