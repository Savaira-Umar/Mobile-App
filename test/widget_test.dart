import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savaira/main.dart';

void main() {
  testWidgets('Savaira App navigation and today screen smoke test (S21 Ultra)',
      (WidgetTester tester) async {
    // Configure portrait mobile screen dimensions (S21 Ultra: 1080x2400)
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    // Build app wrapped in ProviderScope
    await tester.pumpWidget(const ProviderScope(child: SavairaApp()));
    await tester.pumpAndSettle();

    // Verify Sidebar navigation items
    expect(find.text('Savaira'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('Goals'), findsOneWidget);
    expect(find.text('Namaz'), findsOneWidget);
    expect(find.text('User 2'), findsOneWidget);

    // Verify Today screen core sections
    expect(find.text("Today's Progress"), findsOneWidget);
    expect(find.text("Today's Tasks"), findsOneWidget);
    expect(find.text('+ Add Task'), findsOneWidget);
    expect(find.text('Night Review'), findsOneWidget);

    // Test switching tabs to Goals (tap Goals nav item in sidebar)
    await tester.tap(find.text('Goals'));
    await tester.pumpAndSettle();
    expect(find.text('My Goals 🎯'), findsOneWidget);
    expect(find.text('Improve English'), findsOneWidget);

    // Test switching tabs to Namaz
    await tester.tap(find.text('Namaz'));
    await tester.pumpAndSettle();
    expect(find.text('Namaz'), findsNWidgets(2)); // in sidebar and screen header
    expect(find.text('اللهم تقبل منا'), findsOneWidget);

    // Test switching tabs to User 2 (Locked state)
    await tester.tap(find.text('User 2'));
    await tester.pumpAndSettle();
    expect(find.text('Enter the name to access User 2\'s page'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);

    // Test unlocking User 2 space by entering name "ayesha"
    await tester.enterText(find.byType(TextField), 'ayesha');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Hello, Ayesha 💕'), findsOneWidget);
  });

  testWidgets('Savaira App layout check on smaller screen (Tecno 720x1600)',
      (WidgetTester tester) async {
    // Configure small mobile screen dimensions (Tecno Spark: 720x1600)
    tester.view.physicalSize = const Size(720, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const ProviderScope(child: SavairaApp()));
    await tester.pumpAndSettle();

    // Verify no overflow on Today screen
    expect(find.text("Today's Progress"), findsOneWidget);
    expect(find.text("Today's Tasks"), findsOneWidget);

    // Navigate to Goals
    await tester.tap(find.text('Goals'));
    await tester.pumpAndSettle();
    expect(find.text('My Goals 🎯'), findsOneWidget);

    // Navigate to Namaz
    await tester.tap(find.text('Namaz'));
    await tester.pumpAndSettle();
    expect(find.text('اللهم تقبل منا'), findsOneWidget);
  });
}
