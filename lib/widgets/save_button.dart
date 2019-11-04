import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  final Function saveFunc;

  SaveButton({
    @required this.saveFunc,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            saveFunc();
          },
          child: Container(
            height: 50,
            width: 120,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.green[100],
              border: Border.all(color: Colors.green[300]),
            ),
            child: Text(
              "BÆTA VIÐ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}