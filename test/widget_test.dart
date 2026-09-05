// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:activite4/controllers/weather_controller.dart';
import 'package:activite4/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('app loads with weather search view', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => WeatherController(),
        child: const WeatherApp(),
      ),
    );

    expect(find.text('Recherchez une ville pour afficher la météo.'), findsOneWidget);
    expect(find.text('Entrez une ville'), findsOneWidget);
  });
}
