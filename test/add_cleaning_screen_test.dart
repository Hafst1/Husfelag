import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../lib/screens/cleaning/add_cleaning_screen.dart';
import '../lib/providers/cleaning_provider.dart';
import '../lib/providers/current_user_provider.dart';

final date1 = DateFormat.yMMMMEEEEd()
    .format(
      DateTime.now().subtract(
        Duration(days: 2),
      ),
    )
    .toString();
final date2 = DateFormat.yMMMMEEEEd()
    .format(
      DateTime.now().add(
        Duration(days: 2),
      ),
    )
    .toString();

void main() {
  group('add cleaning form testing:', () {
    testWidgets('should display error messages on no input',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: CurrentUserProvider(),
            ),
            ChangeNotifierProvider.value(
              value: CleaningProvider(),
            ),
          ],
          child: MaterialApp(
            home: AddCleaningScreen(),
          ),
        ),
      );

      var button = find.text('BÆTA VIÐ');
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pump();

      expect(
          find.text('Velja þarf íbúð fyrir þrif á sameign!'), findsOneWidget);
      expect(
          find.text('Fylla þarf út upphafsdagsetningu þrifa!'), findsOneWidget);
      expect(find.text('Fylla þarf út lokadagsetningu þrifa!'), findsOneWidget);
    });

    testWidgets('should display no error messages on valid input',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: CurrentUserProvider(),
            ),
            ChangeNotifierProvider.value(
              value: CleaningProvider(),
            ),
          ],
          child: MaterialApp(
            home: AddCleaningScreen(),
          ),
        ),
      );

      var textFormFields = find.byType(TextFormField);
      expect(textFormFields, findsNWidgets(3));

      var apartmentTextField = textFormFields.at(0);
      var dateFromTextField = textFormFields.at(1);
      var dateToTextField = textFormFields.at(2);

      await tester.enterText(apartmentTextField, '103');
      await tester.enterText(dateFromTextField, date1);
      await tester.enterText(dateToTextField, date2);

      var button = find.text('BÆTA VIÐ');
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pump();

      expect(find.text('Velja þarf íbúð fyrir þrif á sameign!'), findsNothing);
      expect(
          find.text('Fylla þarf út upphafsdagsetningu þrifa!'), findsNothing);
      expect(find.text('Fylla þarf út lokadagsetningu þrifa!'), findsNothing);
    });

    testWidgets('should display error messages on invalid input',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: CurrentUserProvider(),
            ),
            ChangeNotifierProvider.value(
              value: CleaningProvider(),
            ),
          ],
          child: MaterialApp(
            home: AddCleaningScreen(),
          ),
        ),
      );

      var textFormFields = find.byType(TextFormField);
      expect(textFormFields, findsNWidgets(3));

      var dateFromTextField = textFormFields.at(1);
      var dateToTextField = textFormFields.at(2);

      await tester.enterText(dateFromTextField, date2);
      await tester.enterText(dateToTextField, date1);

      var button = find.text('BÆTA VIÐ');
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pump();

      expect(
          find.text(
              'Valin dagsetning á sér stað á eftir lokadagsetningu þrifa!'),
          findsOneWidget);
      expect(
          find.text(
              'Valin dagsetning á sér stað á undan upphafsdagsetningu þrifa!'),
          findsOneWidget);
    });
  });
}
