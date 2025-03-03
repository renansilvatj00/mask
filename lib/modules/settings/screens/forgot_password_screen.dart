import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailSent = false; // Controle do estado do envio

  void _sendPasswordReset() {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      _showMessage("Por favor, insira seu e-mail.");
      return;
    }

    // Simulação do envio de e-mail
    setState(() {
      _isEmailSent = true;
    });

    _showMessage("Se este e-mail estiver cadastrado, você receberá um link de recuperação.");
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Esqueci Minha Senha"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Digite seu e-mail para recuperar a senha:",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),

            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "E-mail",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: _sendPasswordReset,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: Text("Enviar", style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 20),

            if (_isEmailSent)
              Text(
                "Verifique sua caixa de entrada!",
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),

            Spacer(),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Voltar para o login"),
            ),
          ],
        ),
      ),
    );
  }
}
