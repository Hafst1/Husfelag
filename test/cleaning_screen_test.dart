import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../lib/screens/cleaning/cleaning_screen.dart';
import '../lib/providers/current_user_provider.dart';
import '../lib/models/user.dart';

final user1 = UserData(
  id: 'user_id_1',
  email: 'email_1',
  name: 'name_1',
  apartmentId: 'apartment_id_1',
  residentAssociationId: 'res_id_1',
  isAdmin: true,
  userToken: 'user_token_1',
);

final user2 = UserData(
  id: 'user_id_2',
  email: 'email_2',
  name: 'name_2',
  apartmentId: '',
  residentAssociationId: '',
  isAdmin: false,
  userToken: '',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('cleaning screen testing:', () {
    testWidgets('should display add cleaning option for admin',
        (WidgetTester tester) async {
      final currentUserProvider = CurrentUserProvider();
      currentUserProvider.currentUser = user1;
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: currentUserProvider,
            ),
          ],
          child: MaterialApp(
            home: CleaningScreen(),
          ),
        ),
      );
      var addCleaningButton = find.text('Bæta við þrif');
      expect(addCleaningButton, findsOneWidget);
      var viewCleaningListButton = find.text('Yfirlit þrifa');
      expect(viewCleaningListButton, findsOneWidget);
      var viewCleaningTaskListButton = find.text('Verkefnalisti');
      expect(viewCleaningTaskListButton, findsOneWidget);
    });

    testWidgets('should not display add cleaning option for non-admin',
        (WidgetTester tester) async {
      final currentUserProvider = CurrentUserProvider();
      currentUserProvider.currentUser = user2;
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: currentUserProvider,
            ),
          ],
          child: MaterialApp(
            home: CleaningScreen(),
          ),
        ),
      );
      var addCleaningButton = find.text('Bæta við þrif');
      expect(addCleaningButton, findsNothing);
      var viewCleaningListButton = find.text('Yfirlit þrifa');
      expect(viewCleaningListButton, findsOneWidget);
      var viewCleaningTaskListButton = find.text('Verkefnalisti');
      expect(viewCleaningTaskListButton, findsOneWidget);
    });
  });
}
