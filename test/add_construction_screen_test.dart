import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../lib/screens/constructions/add_construction_screen.dart';
import '../lib/providers/constructions_provider.dart';
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
  TestWidgetsFlutterBinding.ensureInitialized();
  group('add construction form testing:', () {
    testWidgets('should display error messages on no input',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: CurrentUserProvider(),
            ),
            ChangeNotifierProvider.value(
              value: ConstructionsProvider(),
            ),
          ],
          child: MaterialApp(
            home: AddConstructionScreen(),
          ),
        ),
      );

      var button = find.text('BÆTA VIÐ');
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pump();

      expect(find.text('Fylla þarf út titil framkvæmdar!'), findsOneWidget);
      expect(find.text('Fylla þarf út upphafsdagsetningu framkvæmdar!'),
          findsOneWidget);
      expect(find.text('Fylla þarf út lokadagsetningu framkvæmdar!'),
          findsOneWidget);
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
              value: ConstructionsProvider(),
            ),
          ],
          child: MaterialApp(
            home: AddConstructionScreen(),
          ),
        ),
      );

      var textFormFields = find.byType(TextFormField);
      expect(textFormFields, findsNWidgets(4));

      var titleTextField = textFormFields.at(0);
      var dateFromTextField = textFormFields.at(1);
      var dateToTextField = textFormFields.at(2);

      await tester.enterText(titleTextField, 'Neyðarfundur í íbúð 103');
      await tester.enterText(
        dateFromTextField,
        date1,
      );
      await tester.enterText(
        dateToTextField,
        date2,
      );

      var button = find.text('BÆTA VIÐ');
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pump();

      expect(find.text('Fylla þarf út titil framkvæmdar!'), findsNothing);
      expect(find.text('Fylla þarf út upphafsdagsetningu framkvæmdar!'),
          findsNothing);
      expect(find.text('Fylla þarf út lokadagsetningu framkvæmdar!'),
          findsNothing);
    });

    testWidgets('should display error msg on invalid dateFrom and dateTo input',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: CurrentUserProvider(),
            ),
            ChangeNotifierProvider.value(
              value: ConstructionsProvider(),
            ),
          ],
          child: MaterialApp(
            home: AddConstructionScreen(),
          ),
        ),
      );

      var textFormFields = find.byType(TextFormField);
      expect(textFormFields, findsNWidgets(4));

      var dateFromTextField = textFormFields.at(1);
      var dateToTextField = textFormFields.at(2);

      await tester.enterText(
        dateFromTextField,
        date2,
      );
      await tester.enterText(
        dateToTextField,
        date1,
      );

      var button = find.text('BÆTA VIÐ');
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pump();

      expect(
          find.text(
              'Valin dagsetning á sér stað á eftir lokadagsetningu framkvæmdar!'),
          findsOneWidget);
      expect(
          find.text(
              'Valin dagsetning á sér stað á undan upphafsdagsetningu framkvæmdar!'),
          findsOneWidget);
    });
  });
}
