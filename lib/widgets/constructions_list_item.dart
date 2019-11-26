import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import './custom_icons_icons.dart';
import '../screens/constructions/construction_detail_screen.dart';
import '../screens/constructions/add_construction_screen.dart';
import '../providers/constructions_provider.dart';
import '../widgets/action_dialog.dart';


class ConstructionsListItem extends StatelessWidget {
  final String id;
  final String title;
  final DateTime dateFrom;
  final DateTime dateTo;

  ConstructionsListItem({
    @required this.id,
    @required this.title,
    @required this.dateFrom,
    @required this.dateTo,
  });

  void _showActionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return ActionDialog(
          deleteFunc: () {
            Provider.of<ConstructionsProvider>(context, listen: false)
                .deleteConstruction(id);
          },
          editFunc: () {
            Navigator.of(ctx).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddConstructionScreen(),
                settings: RouteSettings(arguments: id),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      elevation: 5,
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ConstructionDetailScreen(),
              settings: RouteSettings(arguments: id),
            ),
          );
        },
        contentPadding: EdgeInsets.all(10),
        leading: CircleAvatar(
          backgroundColor: Color.fromRGBO(241, 212, 45, 0.8),
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(6),
            child: FittedBox(
              child: Icon(
                CustomIcons.tools,
                color: Colors.black,
              ),
            ),
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.date_range,
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Text(
                  '${DateFormat.yMMMd().format(dateFrom)} - ${DateFormat.yMMMd().format(dateTo)}',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
        // trailing: IconButton(
        //   icon: Icon(Icons.comment),
        //   color: Colors.grey,
        //   onPressed: () => {},
        // ),
        trailing: IconButton(
          icon: Icon(CustomIcons.dot_3),
          color: Colors.grey,
          onPressed: () => _showActionDialog(context),
        ),
      ),
    );
  }
}
