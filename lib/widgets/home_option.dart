import 'package:flutter/material.dart';

class HomeOption extends StatelessWidget {
  final IconData optionIcon;
  final String optionText;
  final String optionRoute;

  HomeOption({
    @required this.optionIcon,
    @required this.optionText,
    @required this.optionRoute,
  });

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
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: LayoutBuilder(
          builder: (ctx, constraints) {
            return Column(
              children: <Widget>[
                Container(
                  height: constraints.maxHeight * 0.75,
                  child: Icon(
                    optionIcon,
                    color: Color.fromRGBO(54, 60, 67, 1),
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
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Color.fromRGBO(54, 60, 67, 1)),
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
