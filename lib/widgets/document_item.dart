import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/documents_provider.dart';
import '../providers/current_user_provider.dart';
import '../screens/documents/add_document_screen.dart';
import '../widgets/action_dialog.dart';
import '../widgets/custom_icons_icons.dart';

class Document extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final String fileName;
  final String downloadUrl;
  final String folderId;
  final bool isAdmin;
  final bool isAuthor;

  Document({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.fileName,
    @required this.downloadUrl,
    @required this.folderId,
    @required this.isAdmin,
    @required this.isAuthor,
  });

  _launchURL(BuildContext context) async {
    String url = downloadUrl;
    if(await canLaunch(url)) {
      await launch(url);
    } else {
      return printErrorDialog('Ekki tókst að sækja skjal', context); //athuga, væri gott að hafa alert
    }
  }

   Future<void> printErrorDialog(String errorMessage, BuildContext context) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Villa kom upp'),
        content: Text(errorMessage),
        actions: <Widget>[
          FlatButton(
            child: Text('Halda áfram'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _showActionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return ActionDialog(
          deleteFunc: () async{
            final residentAssociationId =
                Provider.of<CurrentUserProvider>(context, listen: false)
                    .getResidentAssociationId();
            Provider.of<DocumentsProvider>(context, listen: false)
                .deleteDocument(residentAssociationId, this.id, this.fileName);
          },
          //ekki hægt að breyta skjalinu sjálfu, athuga
          editFunc: () {
            Navigator.of(ctx).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddDocumentScreen(),
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
      color: Colors.white,
      margin: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 3,
      ),
      child: ListTile(
        onTap: () {
          _launchURL(context);
        },
        leading: CircleAvatar(
          backgroundColor: Color.fromRGBO(125, 185, 244, 0.8),
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(6),
            child: FittedBox(
              child: Icon(
                Icons.file_download,
                color: Colors.black,
              ),
            ),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            decoration: TextDecoration.underline,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
        ),
        trailing: IconButton(
          icon: Icon(CustomIcons.dot_3),
          color: Colors.grey,
          onPressed: () => _showActionDialog(context),
        ),
      ),
    );
  }
}