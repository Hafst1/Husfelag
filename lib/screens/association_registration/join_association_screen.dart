import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/current_user_provider.dart';
import '../../widgets/association_list_item.dart';
import '../../widgets/custom_icons_icons.dart';
import '../../widgets/choice_tab_button.dart';
import '../../models/apartment.dart';
import '../../models/resident_association.dart';

class JoinAssociationScreen extends StatefulWidget {
  @override
  _JoinAssociationScreenState createState() => _JoinAssociationScreenState();
}

class _JoinAssociationScreenState extends State<JoinAssociationScreen> {
  final _textFieldController = TextEditingController();
  String _searchQuery = "";
  var _isInit = true;
  var _isLoading = false;
  var _showApartmentSection = false;
  var _tempAssociationNumber;
  var _selectedChoiceIndex = 0;

  final _form = GlobalKey<FormState>();
  var _newApartment = Apartment(
    id: null,
    apartmentNumber: '',
    accessCode: '',
    residents: List<String>(),
  );

  // fetch associations before widget is built.
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<CurrentUserProvider>(context)
          .fetchAssociations(context)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  // function which updates the search query.
  _changeSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  // function which clears the search field.
  _onClear() {
    setState(() {
      _searchQuery = "";
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _textFieldController.clear());
    });
  }

  // function which switches between options in the apartment section.
  _setSelectedChoiceIndex(int index) {
    setState(() {
      _selectedChoiceIndex = index;
    });
  }

  // function for refreshing and getting the latest associations.
  Future<void> _refreshAssociations() async {
    await Provider.of<CurrentUserProvider>(context).fetchAssociations(context);
  }

  // function for refreshing and getting the latest apartments for a given association id.
  Future<void> _refreshApartments(String residentAssocationId) async {
    if (residentAssocationId.isEmpty) {
      return;
    }
    try {
      await Provider.of<CurrentUserProvider>(context)
          .fetchApartments(residentAssocationId);
    } catch (error) {
      _printErrorDialog('Ekki tókst að hlaða niður íbúðum!');
    }
  }

  // function which switches to the apartment section if the user provides correct
  // access code for a given resident association.
  void _switchToApartmentSection(String id) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<CurrentUserProvider>(context).fetchApartments(id);
      setState(() {
        _tempAssociationNumber = id;
        _showApartmentSection = true;
      });
    } catch (error) {
      await _printErrorDialog('Ekki tókst að hlaða upp íbúðum!');
    }
    setState(() {
      _isLoading = false;
    });
  }

  // function which validates the form when a user tries to add an apartment to 
  // a given resident association. If succesful the user proceeds to app main page.
  void _validateForm() async {
    var isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<CurrentUserProvider>(context)
          .addApartment(_tempAssociationNumber, _newApartment);
      await _printConfirmationDialog(
          'Þú hefur bætt við íbúð og gengið til liðs við húsfélagið!');
    } catch (error) {
      await _printErrorDialog('Ekki tókst að bæta við íbúð!');
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  // function which adds a user to an apartment of a resident association.
  void _joinApartment(String id) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<CurrentUserProvider>(context)
          .joinApartment(_tempAssociationNumber, id);
      await _printConfirmationDialog(
          'Þér hefur verið bætt við tiltekna íbúð í húsfélaginu!');
    } catch (error) {
      await _printErrorDialog('Ekki tókst að bæta þér við tiltekna íbúð!');
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  // function which presents an error dialog.
  Future<void> _printErrorDialog(String errorMessage) {
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

  // function which presents a confirmation dialog.
  Future<void> _printConfirmationDialog(String message) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Skráning tókst!'),
        content: Text(message),
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

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserData = Provider.of<CurrentUserProvider>(context);
    final associations = currentUserData.filteredItems(_searchQuery);
    final apartments = currentUserData.getApartments();
    return Scaffold(
      appBar: AppBar(
        title: Text('Ganga í húsfélag'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            )
          : _showApartmentSection
              ? _buildApartmentSection(currentUserData, apartments)
              : _buildAssociationSection(associations),
    );
  }

  // function which builds the apartment section of the screen.
  Widget _buildApartmentSection(
      CurrentUserProvider currentUserData, List<Apartment> apartments) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            ChoiceTabButton(
              buttonId: 0,
              text: 'bæta við íbúð',
              iconData: Icons.add,
              selectedChoiceIndex: _selectedChoiceIndex,
              onTapFunction: (id) => _setSelectedChoiceIndex(id),
            ),
            Container(
              height: 50.0,
              width: 1.0,
              color: Colors.grey,
            ),
            ChoiceTabButton(
              buttonId: 1,
              text: 'skráðar íbúðir',
              iconData: CustomIcons.home,
              selectedChoiceIndex: _selectedChoiceIndex,
              onTapFunction: (id) => _setSelectedChoiceIndex(id),
            ),
          ],
        ),
        Container(
          height: 1.0,
          width: double.infinity,
          color: Colors.grey,
        ),
        _selectedChoiceIndex == 0
            ? _buildForm(currentUserData)
            : _buildApartmentList(apartments)
      ],
    );
  }

  // function which builds the form to add an apartment to a given
  // resident association.
  Widget _buildForm(CurrentUserProvider currentUserData) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _form,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                hintText: "Íbúðarnúmer...",
                prefixIcon: Icon(Icons.home),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return "Fylla þarf út íbúðarnúmer!";
                }
                if (value.length > 4) {
                  return "Íbúðarnúmer getur ekki verið lengra en 4 stafir á lengd!";
                }
                if (!currentUserData.apartmentIsAvailable(value)) {
                  return "Viðkomandi íbúðarnúmer er nú þegar skráð!";
                }
                return null;
              },
              onSaved: (value) {
                _newApartment = Apartment(
                  id: _newApartment.id,
                  apartmentNumber: value,
                  accessCode: _newApartment.accessCode,
                  residents: [currentUserData.getId()],
                );
              },
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Aðgangskóði íbúðar...",
                prefixIcon: Icon(Icons.lock),
                suffixIcon: Icon(Icons.visibility_off),
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (value) {
                if (value.length < 6) {
                  return "Lykilorð þarf að vera að minnsta kosti 6 stafir á lengd!";
                }
                return null;
              },
              onSaved: (value) {
                _newApartment = Apartment(
                  id: _newApartment.id,
                  apartmentNumber: _newApartment.apartmentNumber,
                  accessCode: value,
                  residents: [currentUserData.getId()],
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  onPressed: _validateForm,
                  child: Text('BÆTA VIÐ'),
                  color: Colors.green[200],
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // function which builds the list of pre-existing apartments which the user
  // can join if he can provide the correct access code.
  Widget _buildApartmentList(List<Apartment> apartments) {
    return Expanded(
      child: RefreshIndicator(
        color: Theme.of(context).primaryColor,
        onRefresh: () => _refreshApartments(_tempAssociationNumber),
        child: Container(
          padding: const EdgeInsets.only(
            top: 5,
            bottom: 5,
          ),
          child: ListView.builder(
            itemCount: apartments.length,
            itemBuilder: (ctx, i) => AssociationListItem(
              id: apartments[i].id,
              title: 'Íbúð ' + apartments[i].apartmentNumber,
              accessCode: apartments[i].accessCode,
              iconData: Icons.home,
              buttonText: 'Staðfesta',
              func: (id) => _joinApartment(id),
            ),
          ),
        ),
      ),
    );
  }

  // function which builds the association section of the screen, where the user
  // can search for resident association and join one, if he can provide the 
  // correct access code.
  Widget _buildAssociationSection(List<ResidentAssociation> associations) {
    return Column(
      children: <Widget>[
        TextField(
          controller: _textFieldController,
          onChanged: (value) => _changeSearchQuery(value),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(
              top: 25,
              bottom: 25,
            ),
            hintText: "Leita...",
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.clear,
                color: _searchQuery == "" ? Colors.white : Colors.grey,
              ),
              onPressed: () => _onClear(),
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            color: Theme.of(context).primaryColor,
            onRefresh: () => _refreshAssociations(),
            child: Container(
              padding: const EdgeInsets.only(
                top: 5,
                bottom: 5,
              ),
              child: ListView.builder(
                itemCount: associations.length,
                itemBuilder: (ctx, i) => AssociationListItem(
                  key: ValueKey(associations[i].id),
                  id: associations[i].id,
                  title: associations[i].address,
                  accessCode: associations[i].accessCode,
                  iconData: CustomIcons.apartment,
                  buttonText: 'Halda áfram',
                  func: (id) => _switchToApartmentSection(id),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
