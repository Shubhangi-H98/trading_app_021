import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trading_app_021/data/datasources/local_storage_service.dart';
import 'package:trading_app_021/main.dart';

void main() {
  testWidgets('App initialization smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final localStorageService = LocalStorageService(prefs);

    await tester.pumpWidget(TradingApp(
      localStorageService: localStorageService,
      prefs: prefs,
    ));

    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.byType(TradingApp), findsOneWidget);
  });
}