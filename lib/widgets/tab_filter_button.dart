import 'package:flutter/material.dart';

class TabFilterButton extends StatelessWidget {
  final int buttonFilterId;
  final String buttonText;
  final Function buttonFunc;
  final double buttonHeight;
  final int filterIndex;

  TabFilterButton(
      {@required this.buttonFilterId,
      @required this.buttonText,
      @required this.buttonFunc,
      @required this.buttonHeight,
      @required this.filterIndex});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => buttonFunc(buttonFilterId),
      child: Container(
        height: buttonHeight,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          border: Border(
            bottom: BorderSide(
              width: 3.5,
              color: filterIndex == buttonFilterId
                  ? Colors.grey[600]
                  : Colors.grey[300],
            ),
          ),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 18,
            fontWeight: filterIndex == buttonFilterId
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
        alignment: Alignment.center,
      ),
    );
  }
}
