import 'package:flutter/material.dart';

class HomeOption extends StatelessWidget {
  final IconData optionIcon;
  final String optionText;
  final String optionRoute;

  HomeOption(
    this.optionIcon,
    this.optionText,
    this.optionRoute,
  );

  void selectOption(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      optionRoute,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => selectOption(context),
      child: Container(
        decoration: BoxDecoration(
          //border: Border.all(color: Colors.lightBlue[100]),
          border: Border.all(color: Colors.grey[400]),
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
        ),
        child: LayoutBuilder(
          builder: (ctx, constraints) {
            return Column(
              children: <Widget>[
                Container(
                  height: constraints.maxHeight * 0.75,
                  child: Icon(
                    optionIcon,
                    size: constraints.maxHeight * 0.4,
                  ),
                ),
                Container(
                  height: constraints.maxHeight * 0.25,
                  padding: EdgeInsets.fromLTRB(
                    constraints.maxWidth * 0.025,
                    constraints.maxHeight * 0.01,
                    constraints.maxWidth * 0.025,
                    constraints.maxHeight * 0.1,
                  ),
                  child: FittedBox(
                    child: Text(
                      optionText,
                      style: TextStyle(
                          //fontSize: constraints.maxHeight * 0.11,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
