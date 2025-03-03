import 'package:flutter/material.dart';
import 'dart:async';
import 'login_screen.dart'; // 🔹 Ajuste o caminho correto

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  /// 🔹 Aguarda 3 segundos e navega para a tela de login
  void _navigateToLogin() {
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          // 🔹 Logo do app
          Image.asset(
            "assets/mask_logo.png",
            width: 150,
          ),
          SizedBox(height: 20),

          // 🔹 Nome do App
          Text(
            "MASK",
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
            ),
          ),
          SizedBox(height: 20),

          // 🔹 Descrição breve
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              "Proteja seus dados com segurança e privacidade avançada.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: 30),

          // 🔹 Indicador de carregamento
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ),

          Spacer(),

          // 🔹 Texto do rodapé
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              "Segurança e privacidade em um só lugar.",
              style: TextStyle(color: Colors.white38, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
