import 'package:boh_tourbuch/screens/comments/comments_screen.dart';
import 'package:boh_tourbuch/screens/faq/faq_screen.dart';
import 'package:boh_tourbuch/screens/home/home_screen.dart';
import 'package:boh_tourbuch/screens/orders/orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_navigation_observer.dart';

void main() {
  group("Test Home navigation", () {
    late NavigatorObserver mockObserver;

    Future<void> setupHome(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const HomeScreen(),
          navigatorObservers: [mockObserver],
          routes: {
            "/orders": (_) => const OrdersScreen(),
            "/faq": (_) => const FaqScreen(),
            "/comments": (_) => const CommentsScreen()
          },
        ),
      );
    }

    setUp(() {
      mockObserver = MockNavigatorObserver();
    });

    testWidgets('Click on Orders should navigate to /orders', (WidgetTester tester) async {
      await setupHome(tester);

      expect(find.byType(OrdersScreen), findsNothing);

      await tester.tap(find.widgetWithText(ElevatedButton, "Orders"));
      await tester.pumpAndSettle();

      expect(find.byType(OrdersScreen), findsOneWidget);
    });

    testWidgets('Click on Faq should navigate to /faq', (WidgetTester tester) async {
      await setupHome(tester);

      expect(find.byType(FaqScreen), findsNothing);

      await tester.tap(find.widgetWithText(ElevatedButton, "FAQ"));
      await tester.pumpAndSettle();

      expect(find.byType(FaqScreen), findsOneWidget);
    });

    testWidgets('Click on Comments should navigate to /comments', (WidgetTester tester) async {
      await setupHome(tester);

      expect(find.byType(CommentsScreen), findsNothing);

      await tester.tap(find.widgetWithText(ElevatedButton, "Comments"));
      await tester.pumpAndSettle();

      expect(find.byType(CommentsScreen), findsOneWidget);
    });
  });
}
