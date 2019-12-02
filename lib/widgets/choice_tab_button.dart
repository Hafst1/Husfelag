import 'package:flutter/material.dart';

class ChoiceTabButton extends StatelessWidget {
  final int buttonId;
  final String text;
  final IconData iconData;
  final int selectedChoiceIndex;
  final Function onTapFunction;

  ChoiceTabButton({
    @required this.buttonId,
    @required this.text,
    @required this.iconData,
    @required this.selectedChoiceIndex,
    @required this.onTapFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTapFunction(buttonId),
        child: Container(
          height: 103.5,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 3.5,
                color: buttonId == selectedChoiceIndex
                    ? Colors.grey
                    : Colors.white,
              ),
            ),
          ),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  top: 15,
                  bottom: 15,
                  left: 20,
                  right: 20,
                ),
                child: Icon(
                  iconData,
                  size: 40,
                ),
              ),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'AlegreyaSansSC',
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
