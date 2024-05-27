import 'dart:async';

import 'package:e_commerce_mobile/screen/check_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

// final textTheme = TextTheme(
//
//   bodyText1: TextStyle(fontFamily: 'Montserrat', font: Font.family(customFont)),
//   // Add other text styles as needed
// );
//
// ThemeData darkTheme = ThemeData.dark().copyWith(
//
// );

class ConnectionNotifier extends InheritedNotifier<ValueNotifier<bool>> {
  const ConnectionNotifier({
    super.key,
    required super.notifier,
    required super.child,
  });

  static ValueNotifier<bool> of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ConnectionNotifier>()!
        .notifier!;
  }
}

void main() async {
  final hasConnection = await InternetConnectionChecker().hasConnection;

  runApp(ConnectionNotifier(
      notifier: ValueNotifier(hasConnection), child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final StreamSubscription<InternetConnectionStatus> listener;

  @override
  void initState() {
    super.initState();
    listener = InternetConnectionChecker().onStatusChange.listen((status) {
      final notifier = ConnectionNotifier.of(context);
      notifier.value = status == InternetConnectionStatus.connected ? true : false;
    });
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(brightness: Brightness.dark, fontFamily: 'Montserrat'),
      home: const CheckPage(),
    );
  }
}
