import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/current_user_provider.dart';
import '../providers/documents_provider.dart';
import '../screens/documents/add_document_screen.dart';
import '../widgets/add_dialog.dart';

class AddOption extends StatelessWidget {
  
  final IconData optionIcon;
  final String optionText;

  AddOption({
    @required this.optionIcon,
    @required this.optionText,
  });

  final _addFolderController = TextEditingController(); 
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

  void addNewFolder(BuildContext context){
    var folderData = Provider.of<DocumentsProvider>(context);
    var alert = new AlertDialog(
      content: TextFormField(
        controller: _addFolderController,
        validator: (value){
          if(value.isEmpty){
            return "Veldu nafn á möppu";
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: "NAFN Á MÖPPU"
        ),
      ),
      actions: <Widget>[
        FlatButton.icon(
          onPressed: () async {
            if(_addFolderController.text != "" && folderData.folderTitleExists(_addFolderController.text) == false) {
              final residentAssociationId = Provider.of<CurrentUserProvider>(context, listen: false)
              .getResidentAssociationNumber();
              try {
                await folderData.addFolder(residentAssociationId, _addFolderController.text);
                Navigator.of(context, rootNavigator: true).pop();
                _addFolderController.clear();
              } catch (error) {
                  await printErrorDialog('Ekki tókst að bæta við möppu!', context);
              }
            } else {
              await printErrorDialog('Veldu nafn á möppu\nEkki er leyfilegt að velja nafn á möppu sem er nú þegar til!', context);
              _addFolderController.clear();
            }
          },
          icon: Icon(Icons.add), 
          label: Text("BÆTA"),
          textColor: Colors.blue
        ),
        FlatButton.icon(
          onPressed: (){
            Navigator.of(context, rootNavigator: true).pop();
            _addFolderController.clear();
          }, 
          icon: Icon(Icons.close), 
          label: Text("HÆTTA VIÐ"), 
          textColor: Colors.blue
        ),
      ],
    );
    showDialog(context: context, builder: (_) => alert);
  }

   void selectOption(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AddDialog(
          //þarf aðeins að laga þetta/næ ekki að pop().þegar ég adda möppu.
          addFolderFunc: () {
             addNewFolder(context);
          },
          addFileFunc: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddDocumentScreen(),
              ),
            );
            Navigator.of(ctx).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => selectOption(context),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.10,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[600]), 
                  ),
                color: Colors.grey[200],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                          left: constraints.maxWidth * 0.1,
                          right: constraints.maxWidth * 0.05,
                          top: constraints.maxWidth * 0.11,
                          bottom: constraints.maxWidth * 0.11,
                        ),
                        width: constraints.maxWidth * 0.35,
                      ),
                      Icon(optionIcon),
                      Container(
                        alignment: Alignment.center,
                        width: constraints.maxWidth * 0.05,
                      ),
                      Text(
                        optionText,
                        style: TextStyle(
                        fontSize: 18,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        }
}