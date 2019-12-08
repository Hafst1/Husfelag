import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/documents_provider.dart';
import '../providers/current_user_provider.dart';
import '../widgets/action_dialog.dart';
import '../widgets/custom_icons_icons.dart';
import '../screens/documents/add_document_screen.dart';

class DocumentItem extends StatelessWidget {
  final String id;
  final String title;
  final String fileName;
  final String downloadUrl;
  final String folderId;
  final bool isAdmin;
  final bool isAuthor;

  DocumentItem({
    @required this.id,
    @required this.title,
    @required this.fileName,
    @required this.downloadUrl,
    @required this.folderId,
    @required this.isAdmin,
    @required this.isAuthor,
  });

  // function which launches an URL.
  void launchURL(BuildContext context) async {
    try {
      String url = downloadUrl;
      if (await canLaunch(url)) {
        await launch(url);
      }
    } catch (error) {
      await printErrorDialog('Ekki tókst að sækja skjal', context);
    }
  }

  // functions which prints an error dialog.
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

  // function which shows an action dialog, where user can choose to edit a
  // document or to delete it.
  void showActionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return ActionDialog(
          deleteFunc: () {
            final residentAssociationId =
                Provider.of<CurrentUserProvider>(context)
                    .getResidentAssociationId();
            Provider.of<DocumentsProvider>(context)
                .deleteDocument(residentAssociationId, id, folderId, fileName);
          },
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
        contentPadding: EdgeInsets.only(
          top: 10,
          bottom: 15,
          left: 10,
          right: 10,
        ),
        onTap: () => launchURL(context),
        leading: CircleAvatar(
          backgroundColor: Color.fromRGBO(
            125,
            185,
            244,
            0.8,
          ),
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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            Text(
              fileName.split('!!').last,
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(CustomIcons.dot_3),
          color: Colors.grey,
          onPressed: () => showActionDialog(context),
        ),
      ),
    );
  }
}
