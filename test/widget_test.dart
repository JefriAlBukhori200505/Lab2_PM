import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:uts_lab_pemmob/main.dart';
import 'package:uts_lab_pemmob/providers/theme_provider.dart';
import 'package:uts_lab_pemmob/providers/user_provider.dart';

void main() {
  testWidgets('Halaman login tampil', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: const KuisApp(),
      ),
    );

    expect(find.text('Selamat Datang!'), findsOneWidget);
    expect(find.text('Mulai Kuis'), findsOneWidget);
  });
}
