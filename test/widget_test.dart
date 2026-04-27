import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dazz_camera_ui/camera_menu_page.dart';
import 'package:dazz_camera_ui/camera_option.dart';
import 'package:dazz_camera_ui/main.dart';

void main() {
  test('app widget can be created', () {
    expect(const DazzPrototypeApp(), isA<Widget>());
  });

  testWidgets('camera menu shows two rows and an apply action', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: CameraMenuPage(initialOption: cameraOptions.first)),
    );

    expect(find.byKey(const ValueKey('recording-options-row')), findsOneWidget);
    expect(find.byKey(const ValueKey('capture-options-row')), findsOneWidget);
    expect(find.text('Original'), findsNWidgets(2));
    expect(
      find.byKey(const ValueKey('apply-camera-option-button')),
      findsOneWidget,
    );
    expect(find.text('Apply'), findsOneWidget);
    expect(find.text('Close'), findsNothing);
    expect(find.textContaining('Choose'), findsNothing);
  });
}
