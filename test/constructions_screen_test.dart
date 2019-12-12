import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/screens/constructions/constructions_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('should display main options in constructions section',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ConstructionsScreen(),
      ),
    );

    var addConstructionButton = find.text('Bæta við framkvæmd');
    expect(addConstructionButton, findsOneWidget);

    var viewConstructionsListButton = find.text('Yfirlit framkvæmda');
    expect(viewConstructionsListButton, findsOneWidget);
  });
}
