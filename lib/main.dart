import 'package:flutter/material.dart';
import 'package:mask/modules/settings/screens/welcome.dart';
import 'package:mask/modules/settings/screens/forgot_password_screen.dart';
import 'package:mask/modules/settings/screens/settings_home.dart';
import 'package:mask/modules/settings/screens/my_network_screen.dart';
import 'package:mask/modules/settings/screens/last_alerts_screen.dart';
import 'package:mask/modules/settings/screens/select_panic_user_screen.dart';
import 'package:mask/modules/settings/screens/panic_timeline_screen.dart';

void main() {
  runApp(SecurityLockApp());
}

class SecurityLockApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mask Security',
      theme: ThemeData.dark(),

      // 🔹 Usamos `onGenerateRoute` para maior controle das rotas
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => WelcomeScreen());
          case '/forgot-password':
            return MaterialPageRoute(builder: (context) => ForgotPasswordScreen());
          case '/settings-home':
            return MaterialPageRoute(builder: (context) => SettingsHomeScreen());
          case '/my-network':
            return MaterialPageRoute(builder: (context) => MyNetworkScreen());
          case '/last-alerts':
            return MaterialPageRoute(builder: (context) => LastAlertsScreen());
          case '/select-panic-user':
            return MaterialPageRoute(builder: (context) => SelectPanicUserScreen());
          case '/panic-timeline':
            final args = settings.arguments as Map<String, String>?;
            return MaterialPageRoute(builder: (context) => PanicTimelineScreen(), settings: settings);

          default:
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                body: Center(child: Text('Rota não encontrada!')),
              ),
            );
        }
      },
    );
  }
}
