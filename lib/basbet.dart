import 'package:flutter/material.dart';

class BasBet extends StatelessWidget {
  const BasBet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, 
      body: Stack(
        children: [
          // 🖼 Артқы фон суреті
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/cake_bg.jpg'), // Сіздің торт суретіңіз
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 🌟 Жұмсақ градиенттік фильтр (төменнен жоғарыға қаралайды)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.1), 
                  Colors.black.withOpacity(0.5),
                ],
                stops: const [0.6, 1.0], 
              ),
            ),
          ),

          // 📝 Мазмұн
          SafeArea( 
            // 📌 Өзгеріс: Горизонталды padding сақтап, жоғарғы padding-ті 15.0-ге орнаттық
            child: Padding(
              padding: const EdgeInsets.only(
                top: 15.0, // Логотипті сәл төмен түсіру үшін
                left: 25.0, 
                right: 25.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🧁 Логотип және атау 
                  Row(
                    children: [
                      const Icon(Icons.cake_outlined, color: Colors.white, size: 30), 
                      const SizedBox(width: 10),
                      const Text(
                        "Choco House",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(blurRadius: 10.0, color: Colors.black54),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Мәтінді сәл жоғары жылжыту үшін аралықты кішірейтеміз
                  const SizedBox(height: 100), 

                  // 🍰 Орталық жазу
                  const Center(
                    child: Text(
                      'Торт — это как объятие,\nтолько со сливочным кремом.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700, 
                        fontStyle: FontStyle.italic, 
                        height: 1.4,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black, 
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(), 

                  // 🔘 Батырмалар (Төменгі бөлікте)
                  Column(
                    children: [
                      _AuthButton(
                        text: 'Войти',
                        color: const Color(0xFF381F3B), 
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                      ),
                      const SizedBox(height: 15),
                      _AuthButton(
                        text: 'Регистрация',
                        color: const Color(0xFFB5707F), 
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 40), 
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const _AuthButton({
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color, 
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), 
        ),
        elevation: 8, 
        shadowColor: Colors.black87,
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      child: Text(text),
    );
  }
}

// import 'package:flutter/material.dart';

// const Color _primaryColor = Color(0xFFE9B086); 
// const Color _darkBrown = Color(0xFF8B4513); 
// const Color _lightBrown = Color(0xFFD2B48C); 
// const Color _logoColor = Colors.black;
// const Color _textColor = Colors.black;

// class BasBet extends StatelessWidget {
//   const BasBet({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: _primaryColor,
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             ClipPath(
//               clipper: CustomClipperWidget(),
//               child: Container(
//                 height: size.height * 0.4,
//                 width: double.infinity,
//                 decoration: const BoxDecoration(
//                   color: Color(0xFFCC7F43), 
//                 ),
//                 child: const Center(
//                   child: Text(
//                     '🍪', 
//                     style: TextStyle(fontSize: 100),
//                   ),
//                 ),
//               ),
//             ),
            
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 40.0),
//               child: Column(
//                 children: <Widget>[
//                   SizedBox(height: size.height * 0.05),

//                   const Text.rich(
//                     TextSpan(
//                       text: 'Choco',
//                       style: TextStyle(
//                           fontSize: 40,
//                           fontWeight: FontWeight.bold,
//                           color: _logoColor),
//                       children: <TextSpan>[
//                         TextSpan(
//                             text: ' House',
//                             style: TextStyle(
//                                 fontSize: 40,
//                                 fontWeight: FontWeight.bold,
//                                 color: _logoColor)),
//                       ],
//                     ),
//                   ),
//                   const Text(
//                     'Тәтті сүйетіндер үшін шынайы махаббатпен!',
//                     style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 255, 255, 255)),
//                   ),

//                   SizedBox(height: size.height * 0.1),

//                   _AuthButton(
//                     text: 'Войти',
//                     color: _darkBrown,
//                     onPressed: () {
//                       Navigator.pushNamed(context, '/login');
//                     },
//                   ),
//                   const SizedBox(height: 15),

//                   _AuthButton(
//                     text: 'Регистрация',
//                     color: _lightBrown,
//                     onPressed: () {
//                       Navigator.pushNamed(context, '/signup');
//                     },
//                   ),
//                 ],
//               ),
//             ),
            
//             SizedBox(height: size.height * 0.1),
            
//             const Text(
//               'Сізді көргенімізге қуаныштымыз!',
//               style: TextStyle(color: Color.fromARGB(179, 0, 0, 0), fontSize: 12, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _AuthButton extends StatelessWidget {
//   final String text;
//   final Color color;
//   final VoidCallback onPressed;

//   const _AuthButton({required this.text, required this.color, required this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color,
//         foregroundColor: Colors.white,
//         minimumSize: const Size(double.infinity, 50),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//       ),
//     );
//   }
// }

// class CustomClipperWidget extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     Path path = Path();
//     path.lineTo(0, size.height * 0.7);
//     path.quadraticBezierTo(
//       size.width / 2, 
//       size.height, 
//       size.width, 
//       size.height * 0.7,
//     );
//     path.lineTo(size.width, 0);
//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }