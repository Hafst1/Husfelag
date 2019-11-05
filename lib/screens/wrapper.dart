import 'package:flutter/material.dart';
import 'package:husfelagid/screens/authenticate/authenticate.dart';
import 'package:provider/provider.dart';
import 'package:husfelagid/models/user.dart';

import 'tabs_screen.dart';
import 'package:husfelagid/providers/constructions_provider.dart';
import 'package:husfelagid/providers/meetings_provider.dart';
import 'package:husfelagid/providers/cleaning_provider.dart';
import 'package:husfelagid/providers/cleaning_task_provider.dart';
import 'package:husfelagid/providers/documents_provider.dart';
import 'package:husfelagid/providers/documents_folder_provider.dart';


class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);

    // return either home or authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return MultiProvider(
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
            value: CleaningTaskProvider(),
          ),
          ChangeNotifierProvider.value(
            value: DocumentsProvider(),
          ),
          ChangeNotifierProvider.value(
            value: DocumentsFolderProvider(),
          )
        ],
        child: TabsScreen(),
      );
    }
  }
}
