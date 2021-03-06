import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../lib/screens/meetings/add_meeting_screen.dart';
import '../lib/providers/meetings_provider.dart';
import '../lib/providers/current_user_provider.dart';

final date = DateFormat.yMMMMEEEEd()
    .format(
      DateTime.now().add(
        Duration(days: 2),
      ),
    )
    .toString();

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('add meeting form testing:', () {
    testWidgets('should display no error messages on valid input',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: CurrentUserProvider(),
            ),
            ChangeNotifierProvider.value(
              value: MeetingsProvider(),
            ),
          ],
          child: MaterialApp(
            home: AddMeetingScreen(),
          ),
        ),
      );

      var textFormFields = find.byType(TextFormField);
      expect(textFormFields, findsNWidgets(6));

      var titleTextField = textFormFields.at(0);
      var dateTextField = textFormFields.at(1);
      var timeFromTextField = textFormFields.at(2);
      var timeToTextField = textFormFields.at(3);
      var locationTextField = textFormFields.at(4);

      var button = find.text('BÓKA');
      expect(button, findsOneWidget);

      await tester.enterText(titleTextField, 'Neyðarfundur');
      await tester.enterText(dateTextField, date);
      await tester.enterText(timeFromTextField, '18:00');
      await tester.enterText(timeToTextField, '20:00');
      await tester.enterText(locationTextField, 'Íbúð 103');

      await tester.tap(button);
      await tester.pump();

      expect(find.text('Fylla þarf út titil fundar!'), findsNothing);
      expect(find.text('Útvega þarf dagsetningu fundar!'), findsNothing);
      expect(find.text('Útvega þarf tímasetningu!'), findsNothing);
      expect(find.text('Fylla þarf út staðsetningu fundar!'), findsNothing);
    });
  });
}
