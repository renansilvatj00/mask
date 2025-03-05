import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SelectPanicUserScreen extends StatefulWidget {
  @override
  _SelectPanicUserScreenState createState() => _SelectPanicUserScreenState();
}

class _SelectPanicUserScreenState extends State<SelectPanicUserScreen> {
  List<Map<String, String>> approvedUsers = [];

  @override
  void initState() {
    super.initState();
    _loadApprovedUsers();
  }

  /// 🔹 Carrega os usuários aprovados da rede segura salvos no SharedPreferences
  Future<void> _loadApprovedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedContacts = prefs.getString("safe_network_users");

    if (savedContacts != null) {
      List<dynamic> decodedList = json.decode(savedContacts);
      setState(() {
        approvedUsers = decodedList
            .map((item) => Map<String, String>.from(item))
            .where((user) => user["status"] == "accepted") // 🔹 Filtra apenas os usuários aprovados
            .toList();
      });
    }

    // 🔹 Garante que Edson Silva esteja sempre disponível
    bool edsonExists = approvedUsers.any((user) => user["username"] == "@edson");
    if (!edsonExists) {
      setState(() {
        approvedUsers.add({
          "name": "Edson Silva",
          "email": "edson@email.com",
          "username": "@edson",
          "status": "accepted",
        });
      });
    }
  }

  /// 🔹 Navega para a timeline do usuário selecionado
  void _navigateToPanicTimeline(Map<String, String> user) {
    Navigator.pushNamed(
      context,
      '/panic-timeline',
      arguments: user,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Selecionar Usuário"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Selecione um usuário da sua rede segura para visualizar os eventos de pânico.",
              style: TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // 🔹 Exibe lista de usuários aprovados
            Expanded(
              child: ListView.builder(
                itemCount: approvedUsers.length,
                itemBuilder: (context, index) {
                  final user = approvedUsers[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: Icon(Icons.person, color: Colors.blueAccent),
                      title: Text(user["name"]!, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(user["email"]!),
                      trailing: Icon(Icons.arrow_forward, color: Colors.blueAccent),
                      onTap: () {
                        _navigateToPanicTimeline(user);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
