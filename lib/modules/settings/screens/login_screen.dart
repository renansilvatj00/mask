import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔹 Logo
            Image.asset(
              "assets/mask_logo.png",
              width: 120,
            ),
            SizedBox(height: 20),

            // 🔹 Título
            Text(
              "Bem-vindo",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),

            // 🔹 Campo de Email
            TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 10),

            // 🔹 Campo de Senha
            TextField(
              style: TextStyle(color: Colors.white),
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Senha",
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),

            // 🔹 Botão de Login
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/settings-home");
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Entrar",
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 10),

            // 🔹 Botão de Login com Google
            Container(
              margin: EdgeInsets.only(top: 16), // 🔹 Espaço extra acima do botão
              child: OutlinedButton(
                onPressed: () {
                  // Aqui faremos a autenticação com o Google futuramente
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // 🔹 Ajuste fino no padding
                  side: BorderSide(color: Colors.white54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center, // 🔹 Melhor alinhamento
                  children: [
                    Image.asset("assets/google.png", width: 24, height: 24), // 🔹 Ajuste no tamanho do ícone
                    SizedBox(width: 12),
                    Text(
                      "Entrar com Google",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500, // 🔹 Texto levemente mais destacado
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "/forgot-password");
              },
              child: Text(
                "Esqueci minha senha",
                style: TextStyle(color: Colors.blueAccent, fontSize: 16),
              ),
            ),

            // 🔹 Link para cadastro
            GestureDetector(
              onTap: () {
                // Navegar para a tela de cadastro (vamos criar depois)
              },
              child: Text(
                "Criar uma conta",
                style: TextStyle(color: Colors.blueAccent, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
