import 'package:dzaro_assignment/activities/add_products.dart';
import 'package:dzaro_assignment/activities/dashboard.dart';
import 'package:dzaro_assignment/constants.dart';
import 'package:dzaro_assignment/routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DZARO',
      theme: ThemeData(
        primarySwatch: primaryColor,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case dashboardRoute:
            return MaterialPageRoute(
              builder: (_) => const DashboardPage(),
              settings: settings,
            );
          case addProductRoute:
            return MaterialPageRoute(
              builder: (_) => const AddProducts(),
              settings: settings,
            );

          default:
            return null;
        }
      },
      home: const DashboardPage(),
    );
  }
}
