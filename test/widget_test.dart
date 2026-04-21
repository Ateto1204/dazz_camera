import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dazz_camera_ui/main.dart';

void main() {
  testWidgets('filter picker updates preview when a filter is tapped', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Dazz Camera'), findsOneWidget);

    final selectedFilterName = find.byKey(
      const ValueKey('selected-filter-name'),
    );

    expect(selectedFilterName, findsOneWidget);
    expect(tester.widget<Text>(selectedFilterName).data, 'Original');

    final vintageFilterTile = find.byKey(const ValueKey('filter-item-vintage'));

    await tester.ensureVisible(vintageFilterTile);
    await tester.tap(vintageFilterTile);
    await tester.pumpAndSettle();

    expect(tester.widget<Text>(selectedFilterName).data, 'Vintage');
  });
}
