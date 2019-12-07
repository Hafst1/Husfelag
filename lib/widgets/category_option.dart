import 'package:flutter/material.dart';

class CategoryOption extends StatelessWidget {
  final IconData optionIcon;
  final String optionText;
  final String optionRoute;
  final Color optionColor;

  CategoryOption(
    {@required this.optionIcon,
    @required this.optionText,
    @required this.optionRoute,
    @required this.optionColor}
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
          //border: Border.all(color: Colors.grey[600]),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 28.0, // has the effect of softening the shadow
              spreadRadius: 0.0, // has the effect of extending the shadow
              offset: Offset(
                0.0, // horizontal, move right 10
                4.0, // vertical, move down 10
              ),
            )
          ],
          color: optionColor,
          //color: Colors.white,
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
                      color: Colors.white,
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
                      color: Colors.white,
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
