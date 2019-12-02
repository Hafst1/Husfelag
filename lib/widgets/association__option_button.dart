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
          border: Border.all(color: Colors.grey[600]),
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 140,
              child: icon
            ),
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
