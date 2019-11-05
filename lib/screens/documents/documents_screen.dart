import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/documents_folder_provider.dart';
import '../../widgets/documents_folder_item.dart';

class DocumentsScreen extends StatefulWidget {
  static const routeName = '/documents';

    @override
  _DocumentsScreenState createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _addFolderController = TextEditingController(); 

  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  void _addFolderAlert() {
    var alert = new AlertDialog(
      content: TextFormField(
        controller: _addFolderController,
        validator: (value){
          if(value.isEmpty){
            return "Veldu nafn á möppu";
          }
        },
        decoration: InputDecoration(
          hintText: "NAFN Á MÖPPU"
        ),
      ),
      actions: <Widget>[
        FlatButton.icon(
          onPressed: (){
            if(_addFolderController.text != null) { ///virkar ekki?
              final folderData = Provider.of<DocumentsFolderProvider>(context);
              folderData.addFolder(_addFolderController.text);
            }
          }, 
          icon: Icon(Icons.add), 
          label: Text("BÆTA"), //og loka?
          textColor: Colors.blue
        ),
        FlatButton.icon(
          onPressed: (){
              Navigator.of(context, rootNavigator: true).pop();
          }, 
          icon: Icon(Icons.close), 
          label: Text("HÆTTA VIÐ"), 
          textColor: Colors.blue
        ),
      ],
    );
    showDialog(context: context, builder: (_) => alert);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = AppBar(
      title: Text("Skjöl"),
    );
    final heightOfBody = mediaQuery.size.height -
        mediaQuery.padding.top -
        appBar.preferredSize.height -
        kBottomNavigationBarHeight;
    final folderData = Provider.of<DocumentsFolderProvider>(context);
    final folders = folderData.getAllFolders(); 
    return Scaffold(
      appBar: appBar,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 5,
          ),
          height: heightOfBody,
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: folders.length,
                  itemBuilder: (ctx, i) =>DocumentFolder(
                    id: folders[i].id,
                    title: folders[i].title,
                  ),
                )
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        icon: Icon(Icons.add),
        label: Text("Bæta við möppu"),
        onPressed: (){
          _addFolderAlert();
        },
      ),
    );
  }
}