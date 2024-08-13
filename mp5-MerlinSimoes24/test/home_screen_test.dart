import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mp5/models/favorites.dart';
import 'package:mp5/views/home_screen.dart';

Widget createHomeScreen() => ChangeNotifierProvider<Favorites>(
      create: (context) => Favorites(),
      child: MaterialApp(
        home: HomeScreen(),
      ),
    );

void main() {
  group('Home Screen Widget Tests', () {
    testWidgets('Testing AppBar', (tester) async {
      await tester.pumpWidget(createHomeScreen());

      // Verify the presence of the AppBar
      expect(find.byType(AppBar), findsOneWidget);

      // Verify the title of the AppBar
      expect(find.text('The Movie Database 📽'), findsOneWidget);
    });

    testWidgets('Testing Grid Items', (tester) async {
      await tester.pumpWidget(createHomeScreen());

      // Verify the presence of Grid Items
      expect(find.byType(InkWell), findsWidgets);
    });

    testWidgets('Testing Favorites Button', (tester) async {
      await tester.pumpWidget(createHomeScreen());

      // Verify the presence of Favorites Button
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

  });
}
