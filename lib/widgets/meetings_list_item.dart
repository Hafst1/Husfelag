import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import './custom_icons_icons.dart';
import '../screens/meetings/meeting_detail_screen.dart';
import '../screens/meetings/add_meeting_screen.dart';
import '../providers/meetings_provider.dart';
import '../providers/current_user_provider.dart';
import '../widgets/action_dialog.dart';

class MeetingsListItem extends StatelessWidget {
  final String id;
  final String title;
  final DateTime date;
  final String location;

  MeetingsListItem({
    @required this.id,
    @required this.title,
    @required this.date,
    @required this.location,
  });

  void _showActionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return ActionDialog(
          deleteFunc: () {
            final residentAssociationId =
                Provider.of<CurrentUserProvider>(context, listen: false)
                    .getResidentAssociationNumber();
            Provider.of<MeetingsProvider>(context, listen: false)
                .deleteMeeting(residentAssociationId, id);
          },
          editFunc: () {
            Navigator.of(ctx).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddMeetingScreen(),
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
              builder: (context) => MeetingDetailScreen(),
              settings: RouteSettings(arguments: id),
            ),
          );
        },
        contentPadding: EdgeInsets.all(10),
        leading: CircleAvatar(
          backgroundColor: Colors.brown[200],
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(6),
            child: FittedBox(
              child: Icon(
                CustomIcons.group,
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
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.location_on),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                      location,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.date_range),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '${DateFormat.yMMMd().format(date)}',
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.access_time),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                      DateFormat.Hm().format(date).toString(),
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        trailing: IconButton(
          icon: Icon(CustomIcons.dot_3),
          color: Colors.grey,
          onPressed: () => _showActionDialog(context),
        ),
        // trailing: IconButton(
        //   icon: Icon(Icons.check),
        //   color: Colors.green,
        //   onPressed: () => {},
        // ),
      ),
    );
  }
}
