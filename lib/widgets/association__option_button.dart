import 'package:flutter/material.dart';

class AssociationOptionButton extends StatelessWidget {
  final Icon icon;
  final String text;
  final destScreen;

  AssociationOptionButton({
    @required this.icon,
    @required this.text,
    @required this.destScreen,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => destScreen,
          ),
        );
      },
      child: Container(
        height: 150,
        width: 330,
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
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: <Widget>[
            Container(width: 140, child: icon),
            Expanded(
              child: Container(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'AlegreyaSansSC',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
