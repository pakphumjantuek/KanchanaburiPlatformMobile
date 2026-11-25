import 'package:flutter_test/flutter_test.dart';
import 'package:projecte/main.dart';

void main() {
  testWidgets('app renders main page', (tester) async {
    await tester.pumpWidget(const KanchanaburiApp());
    expect(find.text('หน้าแรก'), findsWidgets);
  });
}
