import 'package:flutter/material.dart';
import 'dart:async';
import '../../../widgets/number_pad.dart';
import '../../../widgets/password_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/services.dart'; // 📌 Para fechar o app corretamente

class LockScreen extends StatefulWidget {
  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  String enteredPassword = "";
  String correctPassword = "1234";
  String panicPassword = "9999";
  String restorePassword = "5555"; // 🔹 Senha para restaurar os apps ocultos
  bool isPanicModeActive = false;

  // 🔹 Lista fixa de aplicativos para ocultar
  final List<String> appsParaOcultar = [
    "com.example.mask",
  ];

  @override
  void initState() {
    super.initState();
    _listarAppsInstalados();
    _listarTodosApps();
  }

  void _listarAppsInstalados() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
      includeSystemApps: true, // 🔹 Inclui aplicativos do sistema
      onlyAppsWithLaunchIntent: false, // 🔹 Lista todos os apps, mesmo sem launcher
    );

    for (var app in apps) {
      debugPrint("📦 App encontrado: ${app.packageName} - ${app.appName}");
    }
  }

  void _listarTodosApps() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
      includeSystemApps: true,
      includeAppIcons: false,
      onlyAppsWithLaunchIntent: true, // Garante que sejam apenas apps que podem ser iniciados
    );

    for (var app in apps) {
      debugPrint("📦 App encontrado: ${app.packageName} - ${app.appName}");
    }
  }

  void _handleNumberTap(String number) {
    if (enteredPassword.length < 4) {
      setState(() {
        enteredPassword += number;
      });
    }
    if (enteredPassword.length == 4) {
      _checkPassword();
    }
  }

  void _checkPassword() {
    if (enteredPassword == correctPassword) {
      _unlockDevice();
    } else if (enteredPassword == panicPassword) {
      _triggerPanicMode();
    } else if (enteredPassword == restorePassword) {
      _restoreHiddenApps();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Senha incorreta!")),
      );
      setState(() {
        enteredPassword = "";
      });
    }
  }

  /// 🔹 Desbloqueia o dispositivo e fecha o app
  void _unlockDevice() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("🔓 Dispositivo desbloqueado!")),
    );

    Future.delayed(Duration(milliseconds: 500), () {
      SystemNavigator.pop(); // 🔹 Fecha o app e volta para a home do Android
    });
  }

  /// 🔹 Ativa o modo pânico
  Future<void> _triggerPanicMode() async {
    if (isPanicModeActive) return;

    setState(() {
      isPanicModeActive = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("⚠️ Modo Pânico Ativado!")),
    );

    // 🔹 Salva os apps ocultados para futura restauração
    await _salvarAppsOcultados(appsParaOcultar);

    // 🔹 Oculta os apps (simulação, pois o DeviceApps não tem suporte nativo para esconder)
    for (String app in appsParaOcultar) {
      await _hideApp(app);
    }

    // 🔹 Fecha o app e volta para a home do Android
    Future.delayed(Duration(seconds: 1), () {
      SystemNavigator.pop();
    });
  }

  /// 🔹 Salva os apps ocultados no SharedPreferences
  Future<void> _salvarAppsOcultados(List<String> apps) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('apps_ocultados', apps);
  }

  /// 🔹 Simula a ocultação de um app (disfarça abrindo outro app)
  Future<void> _hideApp(String packageName) async {
    bool isInstalled = await DeviceApps.isAppInstalled(packageName);

    if (isInstalled) {
      await DeviceApps.openApp("com.android.settings"); // 🔹 Abre as configurações para disfarçar
      debugPrint("✅ Aplicativo ocultado (simulado): $packageName");
    } else {
      debugPrint("🚨 App não encontrado: $packageName");
    }
  }

  /// 🔹 Restaura aplicativos ocultados
  Future<void> _restoreHiddenApps() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? appsOcultados = prefs.getStringList('apps_ocultados');

    if (appsOcultados != null && appsOcultados.isNotEmpty) {
      for (String app in appsOcultados) {
        await _showApp(app);
      }
      await prefs.remove('apps_ocultados');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Aplicativos restaurados!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Nenhum aplicativo oculto para restaurar.")),
      );
    }
  }

  /// 🔹 Simula a restauração de um aplicativo ocultado
  Future<void> _showApp(String packageName) async {
    bool isInstalled = await DeviceApps.isAppInstalled(packageName);

    if (isInstalled) {
      await DeviceApps.openApp(packageName); // 🔹 Abre o app novamente
      debugPrint("✅ Aplicativo restaurado: $packageName");
    } else {
      debugPrint("🚨 App não encontrado: $packageName");
    }
  }

  void _clearPassword() {
    setState(() {
      enteredPassword = "";
    });
  }

  void _goBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, "/");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 📌 Fundo da tela
          Stack(
            children: [
              Image.asset(
                "assets/lock_image.jpeg",
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ],
          ),

          // 📌 Conteúdo da tela de bloqueio
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Text(
                "Digite a senha",
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              PasswordIndicator(enteredPassword),
              SizedBox(height: 20),
              NumberPad(
                onNumberTap: _handleNumberTap,
                onClear: _clearPassword,
                onBack: _goBack,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
