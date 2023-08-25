// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:typed_data';

import 'package:beering/ble/bledata_serialization.dart';
import 'package:beering/ble/receivedata_handler.dart';
import 'package:beering/utils/console_logger.dart';
import 'package:beering/utils/hex_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:beering/app/modules/home_tabbar/views/home_tabbar_view.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(HomeTabbarView());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  test("byte data", () {
    // String a = "0xEEEE0003010001";
    // final b = HEXUtil.decode(a);

    // final c = ReceiveDataHandler.parseDataHandler(b);

    // vmPrint(c);

    final a = DateTime.now();
    final c = a.toCustomFormat();
    vmPrint(c);

    final d =
        BLESerialization.getHeartHistoryDataByCurrentByIndex(15).getData();
    vmPrint(d);

    // List<int> e = [0xbb,15];
    // vmPrint(e.toString());
  });
}
