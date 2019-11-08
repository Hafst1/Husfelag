import 'package:flutter/material.dart';

class CategoryOption extends StatelessWidget {
  final IconData optionIcon;
  final String optionText;
  final String optionRoute;

  CategoryOption(
    {@required this.optionIcon,
    @required this.optionText,
    @required this.optionRoute}
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
        height: MediaQuery.of(context).size.height * 0.16,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[600]),
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
                    right: constraints.maxWidth * 0.05,
                    top: constraints.maxWidth * 0.11,
                    bottom: constraints.maxWidth * 0.11,
                  ),
                  width: constraints.maxWidth * 0.35,
                  child: FittedBox(
                    child: Icon(
                      optionIcon,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(
                    left: constraints.maxWidth * 0.05,
                    right: constraints.maxWidth * 0.1,
                  ),
                  width: constraints.maxWidth * 0.65,
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
