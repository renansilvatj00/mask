import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart'; // 🔹 Necessário para fechar o app

class SettingsHomeScreen extends StatefulWidget {
  @override
  _SettingsHomeScreenState createState() => _SettingsHomeScreenState();
}

class _SettingsHomeScreenState extends State<SettingsHomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      _showPermissionsDialog();
    });

    // 🔹 Se quiser exibir o modal apenas uma vez, ative essa linha e comente a de cima:
    // _checkPermissions();
  }

  /// 🔹 Exibe o modal para solicitar permissões
  void _showPermissionsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Permissões Necessárias"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPermissionItem("🔑 Admin do Dispositivo", "Necessário para ocultar apps."),
            _buildPermissionItem("📷 Câmera", "Tirar fotos em modo pânico."),
            _buildPermissionItem("📍 Localização", "Capturar localização em emergências."),
            _buildPermissionItem("🎤 Microfone", "Gravar áudios em modo pânico."),
            _buildPermissionItem("🔔 Notificações", "Receber alertas e push."),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Agora não"),
          ),
          ElevatedButton(
            onPressed: () {
              _requestPermissions();
            },
            child: Text("Conceder Permissões"),
          ),
        ],
      ),
    );
  }

  /// 🔹 Elemento da lista de permissões
  Widget _buildPermissionItem(String title, String description) {
    return ListTile(
      leading: Icon(Icons.check_circle_outline, color: Colors.blueAccent),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(description),
    );
  }

  /// 🔹 Solicita permissões ao usuário
  void _requestPermissions() async {
    Navigator.pop(context); // Fecha o modal

    _grantAdminPermission();
    _grantCameraPermission();
    _grantLocationPermission();
    _grantMicrophonePermission();
    _grantNotificationPermission();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("permissions_granted", true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ Permissões concedidas!")),
    );
  }

  // 🔹 Métodos simulados para solicitar permissões
  void _grantAdminPermission() {
    print("🔑 Permissão de Admin solicitada");
  }

  void _grantCameraPermission() {
    print("📷 Permissão de Câmera solicitada");
  }

  void _grantLocationPermission() {
    print("📍 Permissão de Localização solicitada");
  }

  void _grantMicrophonePermission() {
    print("🎤 Permissão de Microfone solicitada");
  }

  void _grantNotificationPermission() {
    print("🔔 Permissão de Notificações solicitada");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: _buildDrawer(context),
      body: _buildDashboard(),
    );
  }

  // 🔹 Menu lateral (Drawer)
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueAccent),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.settings, color: Colors.white, size: 50),
                SizedBox(height: 10),
                Text(
                  "Configurações",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.people, "Minha Rede Segura", "/my-network"),
          _buildDrawerItem(Icons.warning, "Últimos Alertas", "/last-alerts"),
          _buildDrawerItem(Icons.lock, "Meu App", "/my-app"),
          _buildDrawerItem(Icons.card_membership, "Meu Plano", "/my-plan"),
          _buildDrawerItem(Icons.person, "Meus Dados Pessoais", "/my-data"),
          _buildDrawerItem(Icons.info, "Dicas ao Usuário", "/tips"),
          _buildDrawerItem(Icons.support, "Suporte", "/support"),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.redAccent),
            title: Text("Sair", style: TextStyle(color: Colors.redAccent, fontSize: 16)),
            onTap: () {
              _exitApp(); // 🔹 Fecha o app
            },
          ),
        ],
      ),
    );
  }

  // 🔹 Função para sair do aplicativo
  void _exitApp() {
    SystemNavigator.pop(); // 🔹 Fecha o app no Android
  }

  // 🔹 Item do menu lateral
  Widget _buildDrawerItem(IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title, style: TextStyle(fontSize: 16)),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }

  // 🔹 Dashboard principal
  Widget _buildDashboard() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Dashboard", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          _buildCard("🔔 Últimos Alertas", "Nenhum alerta recente", Icons.warning, "/last-alerts"),
          _buildCard("💬 Últimos Eventos", "Nenhuma conversa ativa", Icons.chat, "/select-panic-user"),
          _buildCard("📜 Plano Atual", "Plano Free (2 contatos)", Icons.card_membership, "/my-plan"),
        ],
      ),
    );
  }

  // 🔹 Cartão da dashboard
  Widget _buildCard(String title, String subtitle, IconData icon, String route) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        onTap: () {
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }
}
