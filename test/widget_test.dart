import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savaira/main.dart';

void main() {
  testWidgets('Phase 0 Savaira splash smoke test', (WidgetTester tester) async {
    // Build our app wrapped in ProviderScope and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: SavairaApp()));
    await tester.pump();

    // Verify key elements on the Phase 0 screen
    expect(find.text('Savaira'), findsOneWidget);
    expect(find.text('Phase 0 Ready'), findsOneWidget);
    expect(find.text('Phase 0 Verified'), findsOneWidget);
  });
}
