import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


const Color _containerColor = Color(0xFFFDEEF7); 
const Color _darkTextPurple = Color(0xFF4A148C); 
const Color _mediumPurple = Color(0xFF9C27B0); 
const Color _textColor = Colors.black87;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email немесе телефон қажет';
    if (value.length < 5) return 'Дұрыс мәлімет енгізіңіз';
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) return 'Қолданушы аты қажет';
    if (value.length < 3) return 'Аты тым қысқа';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Құпия сөз енгізіңіз';
    }

    const int requiredLength = 8;
    final String password = value.trim();

    if (password.length != requiredLength) {
      return 'Құпия сөз дәл $requiredLength таңбадан тұруы керек';
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Кемінде бір үлкен әріп (A-Z) болуы керек';
    }

  
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Кемінде бір сан (0-9) болуы керек';
    }

    if (!password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
      return 'Кемінде бір арнайы таңба (@, #, \$ т.б.) болуы керек';
    }

    return null; 
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Қайталау қажет';
    if (value != passwordController.text.trim()) return 'Құпия сөздер сәйкес емес';
    return null;
  }

  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final email = emailController.text.trim();
    final name = usernameController.text.trim();
    final password = passwordController.text.trim();

    try {
      final url = Uri.parse('http://localhost:5000/api/auth/signup');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name, 
          'email': email,
          'password': password,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? '✅ Тіркелу сәтті өтті!')),
        );
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? '❌ Қате: Тіркелу мүмкін болмады')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Серверге қосылу қатесі: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: screenHeight * 0.0,
            left: -screenWidth * 0.2,
            child: Transform.rotate(
              angle: -0.5,
              child: Image.asset('assets/donut_top_left.png',
                  height: 250, width: 250,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(height: 250, width: 250)),
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.05,
            right: -screenWidth * 0.15,
            child: Transform.rotate(
              angle: 0.8,
              child: Image.asset('assets/donut_bottom_right.png',
                  height: 220, width: 220,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(height: 220, width: 220)),
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: _darkTextPurple),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  width: screenWidth * 0.9,
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
                  padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 40.0),
                  decoration: BoxDecoration(
                    color: _containerColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Регистрация',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w900, color: _darkTextPurple),
                      ),
                      const SizedBox(height: 30),

                      _buildTextField(
                        controller: emailController,
                        label: 'номер телефона или email',
                        validator: _validateEmail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 15),

                      _buildTextField(
                        controller: usernameController,
                        label: 'имя пользователя',
                        validator: _validateUsername,
                      ),
                      const SizedBox(height: 15),

                      _buildTextField(
                        controller: passwordController,
                        label: 'пароль',
                        isPassword: !_isPasswordVisible,
                        validator: _validatePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: _mediumPurple,
                          ),
                          onPressed: () {
                            setState(() => _isPasswordVisible = !_isPasswordVisible);
                          },
                        ),
                      ),
                      const SizedBox(height: 15),

                      _buildTextField(
                        controller: confirmPasswordController,
                        label: 'повторить пароль',
                        isPassword: !_isConfirmPasswordVisible,
                        validator: _validateConfirmPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: _mediumPurple,
                          ),
                          onPressed: () {
                            setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
                          },
                        ),
                      ),
                      const SizedBox(height: 30),

                      _isLoading
                          ? const Center(child: CircularProgressIndicator(color: _mediumPurple))
                          : _AuthButton(
                              text: 'Зарегистрироваться',
                              color: _mediumPurple,
                              onPressed: registerUser,
                            ),
                      const SizedBox(height: 40),

                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: const Text.rich(
                          TextSpan(
                            text: "Уже есть аккаунт? ",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Войти',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _mediumPurple,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration:
          BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: _textColor),
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          errorStyle: const TextStyle(height: 0.5, fontSize: 10, color: Colors.red),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const _AuthButton({required this.text, required this.color, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
        ),
        child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// // 🎨 Түстер палитрасы
// const Color _containerColor = Color(0xFFFDEEF7); // Ашық фиолет фон
// const Color _darkTextPurple = Color(0xFF4A148C); // Қара күлгін
// const Color _mediumPurple = Color(0xFF9C27B0); // Орташа күлгін
// const Color _textColor = Colors.black87;

// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});

//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController = TextEditingController();

//   bool _isLoading = false;
//   bool _isPasswordVisible = false;
//   bool _isConfirmPasswordVisible = false;

//   // 🧠 Валидациялар
//   String? _validateEmail(String? value) {
//     if (value == null || value.isEmpty) return 'Email немесе телефон қажет';
//     if (value.length < 5) return 'Дұрыс мәлімет енгізіңіз';
//     return null;
//   }

//   String? _validateUsername(String? value) {
//     if (value == null || value.isEmpty) return 'Қолданушы аты қажет';
//     if (value.length < 3) return 'Аты тым қысқа';
//     return null;
//   }

//   String? _validatePassword(String? value) {
//     if (value == null || value.isEmpty) return 'Құпия сөз енгізіңіз';
//     if (value.length < 6) return 'Құпия сөз тым қысқа';
//     return null;
//   }

//   String? _validateConfirmPassword(String? value) {
//     if (value == null || value.isEmpty) return 'Қайталау қажет';
//     if (value != passwordController.text.trim()) return 'Құпия сөздер сәйкес емес';
//     return null;
//   }

//   // 🧩 Тіркелу функциясы
//   Future<void> registerUser() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     final email = emailController.text.trim();
//     final name = usernameController.text.trim();
//     final password = passwordController.text.trim();

//     try {
//       // 👇 Егер backend Android эмуляторында болса:
//       // final url = Uri.parse('http://10.0.2.2:5000/api/auth/signup');
//       // 👇 Ал егер Flutter веб не сол компьютерде іске қосылса:
//       final url = Uri.parse('http://localhost:5000/api/auth/signup');

//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'name': name,       // ✅ Қолданушы аты серверге кетеді
//           'email': email,
//           'password': password,
//         }),
//       );

//       final data = json.decode(response.body);

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(data['message'] ?? '✅ Тіркелу сәтті өтті!')),
//         );
//         Navigator.pushReplacementNamed(context, '/home');
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(data['message'] ?? '❌ Қате: Тіркелу мүмкін болмады')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Серверге қосылу қатесі: $e')),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           // 🍩 Фон суреттері
//           Positioned(
//             top: screenHeight * 0.0,
//             left: -screenWidth * 0.2,
//             child: Transform.rotate(
//               angle: -0.5,
//               child: Image.asset('assets/donut_top_left.png',
//                   height: 250, width: 250,
//                   errorBuilder: (context, error, stackTrace) => const SizedBox(height: 250, width: 250)),
//             ),
//           ),
//           Positioned(
//             bottom: screenHeight * 0.05,
//             right: -screenWidth * 0.15,
//             child: Transform.rotate(
//               angle: 0.8,
//               child: Image.asset('assets/donut_bottom_right.png',
//                   height: 220, width: 220,
//                   errorBuilder: (context, error, stackTrace) => const SizedBox(height: 220, width: 220)),
//             ),
//           ),

//           // ⬅️ Артқа
//           Positioned(
//             top: MediaQuery.of(context).padding.top + 10,
//             left: 10,
//             child: IconButton(
//               icon: const Icon(Icons.arrow_back_ios, color: _darkTextPurple),
//               onPressed: () => Navigator.pop(context),
//             ),
//           ),

//           // 🧁 Форма
//           Center(
//             child: SingleChildScrollView(
//               child: Form(
//                 key: _formKey,
//                 child: Container(
//                   width: screenWidth * 0.9,
//                   margin: const EdgeInsets.symmetric(vertical: 20.0),
//                   padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 40.0),
//                   decoration: BoxDecoration(
//                     color: _containerColor,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         spreadRadius: 2,
//                         blurRadius: 15,
//                         offset: const Offset(0, 8),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Text(
//                         'Регистрация',
//                         style: TextStyle(
//                             fontSize: 28, fontWeight: FontWeight.w900, color: _darkTextPurple),
//                       ),
//                       const SizedBox(height: 30),

//                       _buildTextField(
//                         controller: emailController,
//                         label: 'номер телефона или email',
//                         validator: _validateEmail,
//                         keyboardType: TextInputType.emailAddress,
//                       ),
//                       const SizedBox(height: 15),

//                       _buildTextField(
//                         controller: usernameController,
//                         label: 'имя пользователя',
//                         validator: _validateUsername,
//                       ),
//                       const SizedBox(height: 15),

//                       _buildTextField(
//                         controller: passwordController,
//                         label: 'пароль',
//                         isPassword: !_isPasswordVisible,
//                         validator: _validatePassword,
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
//                             color: _mediumPurple,
//                           ),
//                           onPressed: () {
//                             setState(() => _isPasswordVisible = !_isPasswordVisible);
//                           },
//                         ),
//                       ),
//                       const SizedBox(height: 15),

//                       _buildTextField(
//                         controller: confirmPasswordController,
//                         label: 'повторить пароль',
//                         isPassword: !_isConfirmPasswordVisible,
//                         validator: _validateConfirmPassword,
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
//                             color: _mediumPurple,
//                           ),
//                           onPressed: () {
//                             setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
//                           },
//                         ),
//                       ),
//                       const SizedBox(height: 30),

//                       _isLoading
//                           ? const Center(child: CircularProgressIndicator(color: _mediumPurple))
//                           : _AuthButton(
//                               text: 'Зарегистрироваться',
//                               color: _mediumPurple,
//                               onPressed: registerUser,
//                             ),
//                       const SizedBox(height: 40),

//                       TextButton(
//                         onPressed: () {
//                           Navigator.pushReplacementNamed(context, '/login');
//                         },
//                         child: const Text.rich(
//                           TextSpan(
//                             text: "Уже есть аккаунт? ",
//                             style: TextStyle(color: Colors.grey, fontSize: 14),
//                             children: <TextSpan>[
//                               TextSpan(
//                                 text: 'Войти',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: _mediumPurple,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // 🔤 Input builder
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     String? Function(String?)? validator,
//     bool isPassword = false,
//     TextInputType keyboardType = TextInputType.text,
//     Widget? suffixIcon,
//   }) {
//     return Container(
//       decoration:
//           BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
//       child: TextFormField(
//         controller: controller,
//         obscureText: isPassword,
//         style: const TextStyle(color: _textColor),
//         keyboardType: keyboardType,
//         validator: validator,
//         decoration: InputDecoration(
//           hintText: label,
//           hintStyle: const TextStyle(color: Colors.grey),
//           border: InputBorder.none,
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
//           errorStyle: const TextStyle(height: 0.5, fontSize: 10, color: Colors.red),
//           suffixIcon: suffixIcon,
//         ),
//       ),
//     );
//   }
// }

// // 🚀 Батырма виджеті
// class _AuthButton extends StatelessWidget {
//   final String text;
//   final Color color;
//   final VoidCallback onPressed;

//   const _AuthButton({required this.text, required this.color, required this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 5))],
//       ),
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: color,
//           foregroundColor: Colors.white,
//           minimumSize: const Size(double.infinity, 50),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           elevation: 0,
//         ),
//         child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
//       ),
//     );
//   }
// }
