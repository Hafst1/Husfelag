import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Document extends StatelessWidget {
  final String title;
  final String description;
  final String documentItem;
  final String folderId;

  Document(
      {@required this.title,
      @required this.description,
      @required this.documentItem,
      @required this.folderId});

  _launchURL() async {
    String url = documentItem;
    if(await canLaunch(url)) {
      await launch(url);
      print("url: " + url);
    }
    else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      margin: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 3,
      ),
      elevation: 5,
      child: ListTile(
        leading: Icon(Icons.file_download),
        onTap: () {
          _launchURL();
        },
        contentPadding: EdgeInsets.all(10),
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
      ),
    );
  }
}