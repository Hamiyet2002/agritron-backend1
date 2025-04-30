import 'package:flutter/material.dart';
import 'home_screen.dart'; // HomeScreen dosyasını import ediyoruz

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true; // Şifre görünürlüğü için

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF3D6133), // Üst renk
              Color(0xFF5E7238), // Alt renk
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      'LOGIN',
                      style: TextStyle(
                        color: Color(0xFFdbc699),
                        fontSize: 64, // Büyük font
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 50),
                    _buildTextField(
                      hintText: 'Kullanıcı Adı',
                      obscureText: false,
                      controller: _usernameController,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      hintText: 'Şifre',
                      obscureText: _obscureText,
                      controller: _passwordController,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                          color: Color(0xFFd1be89),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Şifremi unuttum',
                          style: TextStyle(color: Color(0xFFd1be89)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8b6b35),
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'GİRİŞ',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: Color(0xFFd1be89),
                            thickness: 1,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'veya',
                            style: TextStyle(color: Color(0xFFd1be89)),
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            color: Color(0xFFd1be89),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSocialButton(
                      text: 'Google ile',
                      imagePath: 'assets/google_logo.png',
                    ),
                    const SizedBox(height: 10),
                    _buildSocialButton(
                      text: 'Instagram ile',
                      imagePath: 'assets/instagram_logo.png',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required bool obscureText,
    required TextEditingController controller,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFFd1be89),
          fontSize: 18,
        ),
        filled: true,
        fillColor: const Color(0xFF294128),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        suffixIcon: suffixIcon,
      ),
      style: const TextStyle(color: Color(0xFFd1be89)),
    );
  }

  Widget _buildSocialButton({required String text, required String imagePath}) {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF294128),
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      icon: Image.asset(
        imagePath,
        width: 24,
        height: 24,
      ),
      label: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFd1be89),
          fontSize: 18,
        ),
      ),
    );
  }

  void _handleLogin() {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username == "admin" && password == "1234") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Hatalı Giriş"),
          content: const Text("Kullanıcı adı veya şifre yanlış."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tamam"),
            ),
          ],
        ),
      );
    }
  }
}
