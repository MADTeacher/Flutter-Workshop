import 'package:flutter/material.dart';
import 'Pages/login_page.dart';
import 'Pages/register_page.dart';
import 'Pages/loading_screen.dart';
import 'Pages/tab_bar.dart';
import 'Pages/edit_user_page.dart';
import 'Pages/detail_page.dart';
import 'Models/car_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,     
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
        '/editUserPage': (context) => const EditUserPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detailPage') {
          final car = settings.arguments as Car;
          
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => DetailPage(car: car),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.fastEaseInToSlowEaseOut;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          );
        }
        return null;
      },
    );
  }
}