import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../lib/screens/cleaning/add_cleaning_task_screen.dart';
import '../lib/providers/cleaning_provider.dart';
import '../lib/providers/current_user_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('add cleaning task form testing:', () {
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
            home: AddCleaningTaskScreen(),
          ),
        ),
      );

      var button = find.text('BÆTA VIÐ');
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pump();

      expect(find.text('Fylla þarf út titil verkefnis!'), findsOneWidget);
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
            home: AddCleaningTaskScreen(),
          ),
        ),
      );

      var textFormFields = find.byType(TextFormField);
      expect(textFormFields, findsNWidgets(2));

      var titleTextField = textFormFields.at(0);
      await tester.enterText(titleTextField, 'Þrífa glugga');

      var button = find.text('BÆTA VIÐ');
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pump();

      expect(find.text('Fylla þarf út titil verkefnis!'), findsNothing);
      expect(
          find.text(
              'Titill verkefnis getur ekki verið meira en 40 stafir á lengd!'),
          findsNothing);
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
            home: AddCleaningTaskScreen(),
          ),
        ),
      );

      var textFormFields = find.byType(TextFormField);
      expect(textFormFields, findsNWidgets(2));

      var titleTextField = textFormFields.at(0);
      await tester.enterText(
          titleTextField, 'Invalid string with more than 40 letters!');

      var button = find.text('BÆTA VIÐ');
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pump();

      expect(find.text('Fylla þarf út titil verkefnis!'), findsNothing);
      expect(
          find.text(
              'Titill verkefnis getur ekki verið meira en 40 stafir á lengd!'),
          findsOneWidget);
    });
  });
}
