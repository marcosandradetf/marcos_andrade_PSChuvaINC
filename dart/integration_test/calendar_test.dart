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



void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Calendar page', () {
    testWidgets('Valida estado inicial', (WidgetTester tester) async {
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
      expect(find.text('Programação'), findsOneWidget);
      expect(find.text('Nov'), findsOneWidget);
      expect(find.text('2023'), findsOneWidget);
      expect(find.text('26'), findsOneWidget);
      expect(find.text('28'), findsOneWidget);
      expect(find.text('Mesa redonda de 07:00 até 08:00'), findsOneWidget);
    });

    testWidgets('Seleciona dia 28 e verifica que a mesa redonda foi renderizada', (WidgetTester tester) async {
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

      // Check that 'Palestra de 09:30 até 10:00' is not on the screen before tapping '28'.
      expect(find.text('Palestra de 09:30 até 10:00'), findsNothing);
      await expectLater(
        find.byType(Calendar),
        matchesGoldenFile('../screenshots/CalendarPage-Day26.png'),
      );

      // Tap on the '28'.
      await tester.tap(find.text('29'));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(Calendar),
        matchesGoldenFile('../screenshots/CalendarPage-Day28.png'),
      );

      // Then check if 'Palestra de 09:30 até 10:00' appears.
      expect(find.text('Palestra de 09:30 até 10:00'), findsOneWidget);
    });

  });
}
