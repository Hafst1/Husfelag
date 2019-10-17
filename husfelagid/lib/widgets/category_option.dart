import 'package:flutter/material.dart';

class CategoryOption extends StatelessWidget {
  final IconData optionIcon;
  final String optionText;
  final String optionRoute;

  CategoryOption(
    @required this.optionIcon,
    @required this.optionText,
    @required this.optionRoute,
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
        height: MediaQuery.of(context).size.height * 0.18,
        decoration: BoxDecoration(
          //border: Border.all(color: Colors.lightBlue[100]),
          border: Border.all(color: Colors.grey[400]),
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    left: constraints.maxWidth * 0.1,
                    right: constraints.maxWidth * 0.075,
                  ),
                  width: constraints.maxWidth * 0.3,
                  child: Icon(
                    optionIcon,
                    size: constraints.maxHeight * 0.4,
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(
                    left: constraints.maxWidth * 0.075,
                    right: constraints.maxWidth * 0.1,
                  ),
                  width: constraints.maxWidth * 0.7,
                  child: Text(
                    optionText,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
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
