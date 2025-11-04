import 'package:flutter/material.dart';
import 'basbet.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import 'custom_app_drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
   
    const primaryColor = Color(0xFFE9B086); 

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Choco House',
      theme: ThemeData(
        scaffoldBackgroundColor: primaryColor,
        primaryColor: primaryColor,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          elevation: 0,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const BasBet(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/drawer': (context) => const CustomAppDrawer(),
      },
    );
  }
}
// import 'package:flutter/material.dart';

// void main() => runApp(const KonditerlikApp());

// class KonditerlikApp extends StatelessWidget {
//   const KonditerlikApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: WelcomePage(),
//     );
//   }
// }

// class WelcomePage extends StatelessWidget {
//   const WelcomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF2E0C9),
//       body: Stack(
//         alignment: Alignment.bottomCenter,
//         children: [
//           Positioned(
//             top: 200,
//             left: -100,
//             right: -100,
//             child: Container(
//               height: 400,
//               decoration: const BoxDecoration(
//                 color: Color(0xFFFDF7F1),
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.elliptical(400, 200),
//                   topRight: Radius.elliptical(400, 200),
//                 ),
//               ),
//             ),
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Padding(
//                 padding: EdgeInsets.only(left: 40, right: 40),
//                 child: Align(
//                   alignment: Alignment.topLeft,
//                   child: Text(
//                     'Konditerlik қызметке \nҚОШ келдіңіз!',
//                     style: TextStyle(fontSize: 26, height: 1.2),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 80),
//               Image.asset('assets/images/girls.png', width: 300),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

