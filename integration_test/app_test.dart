import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:schoolproject/main.dart' as app;

void main() {
  group("Integration Test", () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    testWidgets("app test", (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final buttonTeacher = find.byKey(ValueKey("buttonTeacher"));

      await tester.tap(buttonTeacher);
      await tester.pumpAndSettle();

      /*final textEmail = find.byKey(ValueKey("loginEmail"));
      final textPass = find.byKey(ValueKey("loginPass"));
      final loginButton = find.byKey(ValueKey("loginButton"));

      await tester.enterText(textEmail, "ksonuksun@gmail.com");
      await tester.enterText(textPass, "Kenan.12@");
      await tester.pumpAndSettle();

      await tester.tap(loginButton);
      await tester.pumpAndSettle();*/
    });
  });
}
