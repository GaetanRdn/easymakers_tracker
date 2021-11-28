import 'package:easymakers_tracker/ui/pages/easymakers_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Check widgets', (WidgetTester tester) async {
    // GIVEN
    EasymakersPage page = const EasymakersPage();

    // WHEN
    await tester.pumpWidget(MaterialApp(
      home: page,
    ));

    // THEN
    expect(find.byWidget(page), findsOneWidget);
    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is ListView),
        findsOneWidget);
    expect(
        find.widgetWithIcon(FloatingActionButton, Icons.add), findsOneWidget);
  });
}
