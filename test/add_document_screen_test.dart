import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../lib/screens/documents/add_document_screen.dart';
import '../lib/providers/documents_provider.dart';
import '../lib/providers/current_user_provider.dart';
import '../lib/models/folder.dart';

void main() {
  group('add document form testing:', () {
    testWidgets('should display error messages on no input',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: CurrentUserProvider(),
            ),
            ChangeNotifierProvider.value(
              value: DocumentsProvider(),
            ),
          ],
          child: MaterialApp(
            home: AddDocumentScreen(),
          ),
        ),
      );

      var button = find.text('BÆTA VIÐ');
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pump();

      expect(find.text('Fylla þarf út titil skjals!'), findsOneWidget);
      expect(find.text('Veldu möppu!'), findsOneWidget);
      expect(
        find.text('Ekki er búið að velja skjal til að bæta við!'),
        findsOneWidget,
      );
    });

    testWidgets('should pick a folder successfully',
        (WidgetTester tester) async {
      final documentsProvider = DocumentsProvider();
      documentsProvider.folders.add(Folder(
        id: 'folder_id',
        title: 'Teikningar',
      ));
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: CurrentUserProvider(),
            ),
            ChangeNotifierProvider.value(
              value: documentsProvider,
            ),
          ],
          child: MaterialApp(
            home: AddDocumentScreen(),
          ),
        ),
      );

      var folderDropdownField = find.text('Veldu möppu...');
      expect(folderDropdownField, findsOneWidget);

      await tester.tap(folderDropdownField);
      var selectedFolder = find.text('Teikningar');
      expect(selectedFolder, findsOneWidget);
      await tester.tap(selectedFolder);

      var button = find.text('BÆTA VIÐ');
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pump();

      expect(find.text('Veldu möppu!'), findsNothing);
    });

    testWidgets('should get error msg on invalid title input',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: CurrentUserProvider(),
            ),
            ChangeNotifierProvider.value(
              value: DocumentsProvider(),
            ),
          ],
          child: MaterialApp(
            home: AddDocumentScreen(),
          ),
        ),
      );

      var textFields = find.byType(TextFormField);
      expect(textFields, findsOneWidget);
      var titleTextField = textFields.at(0);
      await tester.enterText(
        titleTextField,
        'Invalid string with more than 40 letters!',
      );

      var button = find.text('BÆTA VIÐ');
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pump();

      expect(
        find.text('Titill skjals getur ekki verið meira en 40 stafir á lengd!'),
        findsOneWidget,
      );
    });
  });
}
