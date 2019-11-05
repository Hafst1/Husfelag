import 'package:flutter/material.dart';
import 'package:husfelagid/models/document_folder.dart';
import 'package:provider/provider.dart';

import './documents_folder_screen.dart';
import '../../widgets/category_option.dart';
import '../../widgets/home_option.dart';
import '../../widgets/custom_icons_icons.dart';
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
  TextEditingController _addFileController = TextEditingController();
  int _selectedFilterIndex = 0;
  String _searchQuery = "";

  _selectFilter(int index) {
    setState(() {
      _selectedFilterIndex = index;
    });
  }

  _changeSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  _onClear() {
    setState(() {
      _searchQuery = "";
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _textFieldController.clear());
    });
  }

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
            return "Mappa getur ekki verið tóm";
          }
        },
        decoration: InputDecoration(
          hintText: "NAFN Á MÖPPU"
        ),
      ),
      actions: <Widget>[
        FlatButton.icon(
          onPressed: (){
            final folderData = Provider.of<DocumentsFolderProvider>(context);
            folderData.addFolder(_addFolderController.text); 
          }, 
          icon: Icon(Icons.add), 
          label: Text("BÆTA"), 
          textColor: Colors.blue
        ),
        FlatButton.icon(
          onPressed: (){

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
    final folderData = Provider.of<DocumentsFolderProvider>(context);
    final folders = folderData.getAllFolders(); 
    final PreferredSizeWidget appBar = AppBar(
      title: Text("Skjöl"),
    );
    return Scaffold(
      appBar: appBar,
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: folders.length,
              itemBuilder: (ctx, i){
                return ListTile(
                  title: DocumentListItem(
                    title: folders[i].title,
                    //route: DocumentsFolderScreen.routeName, //hér þarf route að vera tengt [i]
                  ),
                  onTap: () {
                      Navigator.pushNamed(context, DocumentsFolderScreen.routeName);
                  });
              }
            )
          ),
        ],
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