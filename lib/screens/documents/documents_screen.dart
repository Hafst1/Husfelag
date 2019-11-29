import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/documents_provider.dart';
import '../../screens/documents/add_document_screen.dart';
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

  void _addNewFolder() {
    var alert = new AlertDialog(
      content: TextFormField(
        controller: _addFolderController,
        validator: (value){ ///athuga
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
              Navigator.of(context, rootNavigator: true).pop();
            }
          }, 
          icon: Icon(Icons.add), 
          label: Text("BÆTA"),
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

  void _addFileOrFolderOptions() {
    var alert = new AlertDialog(
      title: new Text("Bæta við.."),
      actions: <Widget>[
        FlatButton.icon(
          onPressed: (){
            Navigator.of(context).push(
              MaterialPageRoute(
                builder:(context) => AddDocumentScreen(),
              )
            );
            Navigator.of(context, rootNavigator: true).pop();
          }, 
          icon: Icon(Icons.add), 
          label: Text("Skjali"),
          textColor: Colors.blue
        ),
        FlatButton.icon(
          onPressed: (){
              Navigator.of(context, rootNavigator: true).pop();
              _addNewFolder();
          }, 
          icon: Icon(Icons.add), 
          label: Text("Möppu"), 
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
          child: Row(
            children: <Widget>[
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: folders.length,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 10,
                  ),
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
        label: Text("Bæta við"),
        onPressed: (){
          _addFileOrFolderOptions();
        },
      ),
    );
  }
}