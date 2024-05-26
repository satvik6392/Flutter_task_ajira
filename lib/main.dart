import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satvik_task/view/export_view.dart';

import 'controllers/profic_pic_controller.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ProfilePicController(),
     child: MyApp()));
}

class MyApp extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Dashboard where all users are listed
      home: const Dashboard(), 
    );
  }
}
