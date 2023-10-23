import 'package:chuva_dart/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:chuva_dart/serialize.dart';
import 'package:chuva_dart/activities.dart';
import 'package:chuva_dart/data.dart';
import 'package:chuva_dart/home_content.dart';
import 'package:chuva_dart/author.dart';
import 'package:chuva_dart/otherActivity.dart';

// Open activity page.
Future<void> loadActivityPage(WidgetTester tester) async {

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF456189),
      systemNavigationBarColor: Colors.white,
    ),
  );
  initializeDateFormatting('pt_BR', null);

  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: Builder(
        builder: (context) {
          return const ChuvaDart();
        },
      ),
    ),
  );

  await tester.pumpAndSettle();
  await tester.tap(find.text('Mesa redonda de 07:00 até 08:00'));
  await tester.pumpAndSettle();
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Activity page', () {
    testWidgets('Verifica elementos da atividade', (WidgetTester tester) async {
      await loadActivityPage(tester);
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(Activity),
        matchesGoldenFile('../screenshots/ActivityPage-Unfavorited.png'),
      );

      expect(find.text('Astrofísica e Cosmologia'), findsOneWidget);
      expect(find.text(' Maputo'), findsOneWidget);
      expect(find.text(' domingo 07:00h - 08:00h'), findsOneWidget);
      expect(find.text('Adicionar à sua agenda'), findsOneWidget);
      expect(find.text('Stephen William Hawking'), findsOneWidget);
    });

    testWidgets('Verifica se favoritar funciona', (WidgetTester tester) async {
      await loadActivityPage(tester);
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(Activity),
        matchesGoldenFile('../screenshots/ActivityPage-Unfavorited.png'),
      );
      await tester.tap(find.text('Adicionar à sua agenda'));
      await tester.pumpAndSettle();

      expect(find.text('Remover da sua agenda'), findsOneWidget);
      await expectLater(
        find.byType(Activity),
        matchesGoldenFile('../screenshots/ActivityPage-Favorited.png'),
      );
    });


  });

}