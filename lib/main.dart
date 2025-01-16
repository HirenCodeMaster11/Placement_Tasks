import 'package:flutter/material.dart';
import 'package:placement_tasks/View/todo.dart';
import 'package:placement_tasks/provider/task-2/login-2.dart';
import 'package:placement_tasks/provider/todo.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'View/task-2/login_page-2.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  // sharedPreferences.getBool('isDarkTheme') ?? false;
  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (context) => TodoProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<TodoProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // themeMode: provider.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      // theme: ThemeData.light(),
      // darkTheme: ThemeData.dark(),
      home: LoginPage(),
    );
  }
}
