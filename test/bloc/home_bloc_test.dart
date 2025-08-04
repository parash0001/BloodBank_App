import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloodbank/features/home/presentation/view_model/home_view_model.dart';

void main() {
  group('HomeViewModel', () {
    late HomeViewModel viewModel;

    setUp(() {
      viewModel = HomeViewModel();
    });

    test('initial state is correct', () {
      expect(viewModel.state.selectedIndex, 0);
      expect(viewModel.state.views.length, 4);
    });

    test('onTabTapped changes selectedIndex', () {
      viewModel.onTabTapped(2);
      expect(viewModel.state.selectedIndex, 2);
    });

    testWidgets('logout navigates to /login', (tester) async {
      final navigatorKey = GlobalKey<NavigatorState>();

      await tester.pumpWidget(MaterialApp(
        navigatorKey: navigatorKey,
        routes: {'/login': (_) => const Text('Login Page')},
        home: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () => viewModel.logout(context),
              child: const Text('Logout'),
            );
          },
        ),
      ));

      await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();

      expect(find.text('Login Page'), findsOneWidget);
    });
  });
}
