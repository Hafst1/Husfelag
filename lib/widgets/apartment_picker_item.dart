import 'package:flutter/material.dart';

class ApartmentPickerItem extends StatelessWidget {
  final String apartment;
  final Function onClickFunc;

  ApartmentPickerItem({
    @required this.apartment,
    @required this.onClickFunc,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClickFunc(context, apartment),
      child: Container(
        child: Column(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.brown[100],
              radius: 30,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Icon(
                    Icons.home,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            FittedBox(
              child: Text(
                'Íbúð ' + apartment,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
