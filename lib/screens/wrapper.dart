import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'tabs_screen.dart';
import '../models/user.dart';
import '../providers/constructions_provider.dart';
import '../providers/meetings_provider.dart';
import '../providers/cleaning_provider.dart';
import '../screens/authenticate/authenticate.dart';
import '../providers/current_user_provider.dart';
import '../screens/association_registration/association_options_screen.dart';
import '../providers/documents_provider.dart';
import '../shared/loading_spinner.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final currentUser =
        Provider.of<CurrentUserProvider>(context, listen: false);
    // return Authenticate page if user has value of null
    if (user == null) {
      return Authenticate();
    } else {
      return FutureBuilder(
        future: currentUser.fetchCurrentUser(user.uid),
        builder: (_, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Container();
            case ConnectionState.waiting:
              return Scaffold(
                body: LoadingSpinner(),
              );
            case ConnectionState.done:
            // currentUser.setResidentAssociationId('Tokyo');
              print(currentUser.getResidentAssociationId());
              currentUser.setResidentAssociationId('');
              print(currentUser.getName());
              print(currentUser.getEmail());
              // send user to home page if he contains a resident association number
              return currentUser.containsRAN()
                  ? MultiProvider(
                      providers: [
                        ChangeNotifierProvider.value(
                          value: ConstructionsProvider(),
                        ),
                        ChangeNotifierProvider.value(
                          value: MeetingsProvider(),
                        ),
                        ChangeNotifierProvider.value(
                          value: CleaningProvider(),
                        ),
                        ChangeNotifierProvider.value(
                          value: DocumentsProvider(),
                        ),
                        ChangeNotifierProvider.value(
                          value: DocumentsFolderProvider(),
                        )
                      ],
                      child: TabsScreen(),
                    )
                  // send user to page where he can create or join a resident assocation
                  // if he doesn't contain resident association number
                  : AssociationOptionsScreen();
            default:
              if (snapshot.hasError) {
                // Gera eittvað error page með valmöguleikum um framhald..
                return null;
              }
              return null;
          }
        },
      );
    }
  }
}
