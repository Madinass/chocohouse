import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const Color _containerColor = Color(0xFFFDEEF7); 
const Color _darkTextPurple = Color(0xFF4A148C);
const Color _mediumPurple = Color(0xFF9C27B0);
const Color _textColor = Colors.black87;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Пароль енгізу қажет';
    }
    if (value.length != 8) {
      return 'Пароль дәл 8 таңбадан тұруы керек';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Кемінде бір бас әріп (A-Z) болуы керек';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Кемінде бір сан (0-9) болуы керек';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Кемінде бір арнайы таңба (@, \#, \$, ...) болуы керек';
    }
    return null;
  }

  String? _validatePhoneOrEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Телефон нөмірін немесе Email енгізу қажет';
    }
    return null;
  }

  Future<void> _loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final url = Uri.parse('http://localhost:5000/api/auth/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': _phoneEmailController.text.trim(),
          'password': _passwordController.text.trim(),
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Кіру сәтті ✅')),
        );
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Қате: Пароль немесе Email/Телефон дұрыс емес ❌')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Желілік қате: серверге қосылу мүмкін емес. $e')),
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _darkTextPurple),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: screenHeight * 0.0,
            left: -screenWidth * 0.2,
            child: Transform.rotate(
              angle: -0.5,
              child: Image.asset('assets/donut_top_left.png', height: 250, width: 250),
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.05,
            right: -screenWidth * 0.15,
            child: Transform.rotate(
              angle: 0.8,
              child: Image.asset('assets/donut_bottom_right.png', height: 220, width: 220),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  width: screenWidth * 0.9,
                  margin: const EdgeInsets.symmetric(vertical: 40.0),
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
                    children: [
                      const Text(
                        'Войти',
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: _darkTextPurple,
                        ),
                      ),
                      const SizedBox(height: 50),
                      _buildTextField(
                        controller: _phoneEmailController,
                        label: 'Номер телефона или Email',
                        isPhone: false,
                        maxLength: 50,
                        validator: _validatePhoneOrEmail,
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                        controller: _passwordController,
                        label: 'Пароль',
                        isPassword: !_isPasswordVisible,
                        validator: _validatePassword,
                        maxLength: 8, 
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
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: const Text('Забыли пароль?', style: TextStyle(fontSize: 12, color: _mediumPurple)),
                            ),
                          ],
                        ),
                      ),

                      
                      _isLoading
                          ? const Center(child: CircularProgressIndicator(color: _mediumPurple))
                          : _AuthButton(text: 'Войти', color: _mediumPurple, onPressed: _loginUser),
                      const SizedBox(height: 40),

                      
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/signup');
                        },
                        child: const Text.rich(
                          TextSpan(
                            text: "У вас еще нет аккаунта? ",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                            children: [
                              TextSpan(
                                text: 'Зарегистрироваться',
                                style: TextStyle(fontWeight: FontWeight.bold, color: _darkTextPurple),
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
    bool isPassword = false,
    bool isPhone = false,
    int? maxLength,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    final isFieldPhone = isPhone && !isPassword;
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: _textColor),
        keyboardType: isFieldPhone ? TextInputType.phone : TextInputType.text,
        
        maxLength: maxLength, 
        validator: validator,
        inputFormatters: isFieldPhone ? [FilteringTextInputFormatter.digitsOnly] : [],
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          counterText: "",
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
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
// const Color _darkTextPurple = Color(0xFF4A148C);
// const Color _mediumPurple = Color(0xFF9C27B0);
// const Color _textColor = Colors.black87;

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _phoneEmailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   bool _rememberMe = false;
//   bool _isLoading = false;
//   bool _isPasswordVisible = false;

//   String? _validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Пароль енгізу қажет';
//     }
//     return null;
//   }

//   String? _validatePhoneOrEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Телефон нөмірін немесе Email енгізу қажет';
//     }
//     if (value.length == 11 && RegExp(r'^[0-9]+$').hasMatch(value)) {
//       return null;
//     }
//     if (value.contains('@') && value.contains('.')) {
//       return null;
//     }
//     return 'Дұрыс телефон нөмірін (11 сан) немесе Email енгізіңіз.';
//   }

//   Future<void> _loginUser() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);
//     try {
//       final url = Uri.parse('http://localhost:5000/api/auth/login');
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           // ✅ НАЗАР АУДАР — бұрын "emailOrPhone" еді, енді "email"
//           'email': _phoneEmailController.text.trim(),
//           'password': _passwordController.text.trim(),
//         }),
//       );

//       final data = json.decode(response.body);

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(data['message'] ?? 'Кіру сәтті ✅')),
//         );

//         // ✅ Кіру сәтті болса — басты бетке өт
//         Navigator.pushReplacementNamed(context, '/home');
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(data['message'] ?? 'Қате: Пароль немесе Email/Телефон дұрыс емес ❌')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Желілік қате: серверге қосылу мүмкін емес. $e')),
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
//           // 🍩 Фондағы суреттер
//           Positioned(
//             top: screenHeight * 0.0,
//             left: -screenWidth * 0.2,
//             child: Transform.rotate(
//               angle: -0.5,
//               child: Image.asset('assets/donut_top_left.png', height: 250, width: 250),
//             ),
//           ),
//           Positioned(
//             bottom: screenHeight * 0.05,
//             right: -screenWidth * 0.15,
//             child: Transform.rotate(
//               angle: 0.8,
//               child: Image.asset('assets/donut_bottom_right.png', height: 220, width: 220),
//             ),
//           ),
//           // 🧁 Негізгі форма
//           Center(
//             child: SingleChildScrollView(
//               child: Form(
//                 key: _formKey,
//                 child: Container(
//                   width: screenWidth * 0.9,
//                   margin: const EdgeInsets.symmetric(vertical: 40.0),
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
//                     children: [
//                       const Text(
//                         'Кіру',
//                         style: TextStyle(
//                           fontSize: 38,
//                           fontWeight: FontWeight.w900,
//                           color: _darkTextPurple,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       const Text(
//                         'Сіздің сүйікті тәттілеріңіз бір шертуде. Жалғастыру үшін кіріңіз.',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontSize: 14, color: _textColor),
//                       ),
//                       const SizedBox(height: 40),

//                       // 📱 Email немесе телефон
//                       _buildTextField(
//                         controller: _phoneEmailController,
//                         label: 'Номер телефона (11 сан) немесе Email',
//                         isPhone: true,
//                         maxLength: 50,
//                         validator: _validatePhoneOrEmail,
//                       ),
//                       const SizedBox(height: 15),

//                       // 🔒 Пароль өрісі
//                       _buildTextField(
//                         controller: _passwordController,
//                         label: 'Пароль',
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
//                       Padding(
//                         padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 Checkbox(
//                                   value: _rememberMe,
//                                   onChanged: (val) => setState(() => _rememberMe = val ?? false),
//                                   activeColor: _mediumPurple,
//                                 ),
//                                 const Text('Запомнить меня', style: TextStyle(fontSize: 12, color: _textColor)),
//                               ],
//                             ),
//                             TextButton(
//                               onPressed: () {},
//                               child: const Text('Забыли пароль?', style: TextStyle(fontSize: 12, color: _mediumPurple)),
//                             ),
//                           ],
//                         ),
//                       ),

//                       // 🚪 Войти батырмасы
//                       _isLoading
//                           ? const Center(child: CircularProgressIndicator(color: _mediumPurple))
//                           : _AuthButton(text: 'Войти', color: _mediumPurple, onPressed: _loginUser),
//                       const SizedBox(height: 40),

//                       // 🆕 Тіркелу сілтемесі
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pushReplacementNamed(context, '/signup');
//                         },
//                         child: const Text.rich(
//                           TextSpan(
//                             text: "Әлі аккаунт жоқ па? ",
//                             style: TextStyle(color: Colors.grey, fontSize: 12),
//                             children: [
//                               TextSpan(
//                                 text: 'Тіркелу',
//                                 style: TextStyle(fontWeight: FontWeight.bold, color: _darkTextPurple),
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

//   // 📋 Input өрістерін құру функциясы
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     bool isPassword = false,
//     bool isPhone = false,
//     int? maxLength,
//     String? Function(String?)? validator,
//     Widget? suffixIcon,
//   }) {
//     final isFieldPhone = isPhone && !isPassword;
//     return Container(
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
//       child: TextFormField(
//         controller: controller,
//         obscureText: isPassword,
//         style: const TextStyle(color: _textColor),
//         keyboardType: isFieldPhone ? TextInputType.phone : TextInputType.text,
//         maxLength: maxLength,
//         validator: validator,
//         inputFormatters: isFieldPhone ? [FilteringTextInputFormatter.digitsOnly] : [],
//         decoration: InputDecoration(
//           hintText: label,
//           hintStyle: const TextStyle(color: Colors.grey),
//           border: InputBorder.none,
//           counterText: "",
//           contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
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
