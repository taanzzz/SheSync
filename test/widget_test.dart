import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SheSyncApp());
    expect(find.text('SheSync Studio'), findsWidgets);
  });
}
