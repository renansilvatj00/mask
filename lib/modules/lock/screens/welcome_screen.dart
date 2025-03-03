import 'package:flutter/material.dart';
import 'dart:async';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String _currentTime = "--:--";
  Timer? _timer;
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _updateTime();
  }

  void _updateTime() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_isMounted) {
        setState(() {
          _currentTime = _getFormattedTime();
        });
      }
    });
  }

  @override
  void dispose() {
    _isMounted = false;
    _timer?.cancel();
    super.dispose();
  }

  String _getFormattedTime() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }

  void _goToLockScreen() {
    try {
      Navigator.pushNamed(context, "/lockscreen");
    } catch (e) {
      debugPrint("Erro ao navegar: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onDoubleTap: _goToLockScreen, // 📌 Dois cliques para desbloquear
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 📌 Fundo da tela sem Blur
            Image.asset("assets/lock_image.jpeg", fit: BoxFit.cover),

            // 📌 Conteúdo centralizado
            Container(
              color: Colors.transparent,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 📌 Relógio digital maior
                    Text(
                      _currentTime,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                    SizedBox(height: 30),

                    // 📌 Ícone de clique
                    Icon(Icons.touch_app, color: Colors.white, size: 50),
                    SizedBox(height: 10),

                    // 📌 Texto indicando a ação
                    Text(
                      "Toque duas vezes para desbloquear",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 5,
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
