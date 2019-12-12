import 'package:flutter/material.dart';

class AssociationListItem extends StatefulWidget {
  final ValueKey key;
  final String id;
  final String title;
  final String accessCode;
  final IconData iconData;
  final String buttonText;
  final Function func;

  AssociationListItem({
    this.key,
    @required this.id,
    @required this.title,
    @required this.accessCode,
    @required this.iconData,
    @required this.buttonText,
    @required this.func,
  });

  @override
  _AssociationListItemState createState() => _AssociationListItemState();
}

class _AssociationListItemState extends State<AssociationListItem> {
  final _form = GlobalKey<FormState>();
  var _isPushed = false;

  // function which presents a text field if item is pushed.
  _presentTextField() {
    setState(() {
      _isPushed = !_isPushed;
    });
  }

  // function which validates the form and sends the id of the 
  // association if the access code is correct.
  void _validateForm() {
    FocusScope.of(context).requestFocus(FocusNode());
    var isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    widget.func(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      elevation: 5,
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: () => _presentTextField(),
            contentPadding: EdgeInsets.all(15),
            leading: Padding(
              padding: EdgeInsets.all(10),
              child: Icon(
                widget.iconData,
                size: 40,
                color: Colors.grey,
              ),
            ),
            title: Text(
              widget.title,
              style: Theme.of(context).textTheme.title,
            ),
          ),
          _isPushed
              ? Column(
                  children: <Widget>[
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    Form(
                      key: _form,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Sláðu inn aðgangskóða...",
                                prefixIcon: Icon(Icons.lock),
                                contentPadding: EdgeInsets.only(
                                  top: 25,
                                  bottom: 25,
                                ),
                                errorMaxLines: 2,
                                errorStyle: TextStyle(fontSize: 15),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Ekki var sleginn inn aðgangskóði!";
                                }
                                if (value != widget.accessCode) {
                                  return "Þú hefur slegið inn rangan aðgangskóða!";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          FlatButton(
                            onPressed: _validateForm,
                            child: Text(
                              widget.buttonText,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            color: Colors.blue[300],
                          ),
                          SizedBox(
                            width: 15,
                          ),
                        ],
                      ),
                    )
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
