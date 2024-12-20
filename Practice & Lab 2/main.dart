import 'package:flutter/material.dart';
import 'Pages/login_page.dart';
import 'Pages/register_page.dart';
import 'Pages/loading_screen.dart';
import 'Pages/tab_bar.dart';
import 'Pages/edit_user_page.dart';
import 'Pages/detail_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoadingScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/customTabBar': (context) => const CustomBottomNavigationBar(),
        '/detailPage': (context) => const DetailPage(),
        '/editUserPage': (context) => const EditUserPage(),
      },
    );
  }
}