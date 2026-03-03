import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suraksham/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: SurakshamApp()));

    // Initial route is /login, verify Login screen elements
    expect(find.text('Welcome to Suraksham'), findsOneWidget);
    expect(find.text('LOG IN'), findsOneWidget);
  });
}
