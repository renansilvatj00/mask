import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MyNetworkScreen extends StatefulWidget {
  @override
  _MyNetworkScreenState createState() => _MyNetworkScreenState();
}

class _MyNetworkScreenState extends State<MyNetworkScreen> {
  final TextEditingController _searchController = TextEditingController();
  final int maxContacts = 2; // 🔹 Plano Free permite até 2 contatos
  List<Map<String, String>> contacts = []; // Lista de contatos cadastrados
  List<Map<String, String>> filteredUsers = [];

  // 🔹 Mock de usuários disponíveis para busca
  final List<Map<String, String>> allUsers = [
    {"name": "João Silva", "email": "joao@email.com", "username": "@joao"},
    {"name": "Maria Souza", "email": "maria@email.com", "username": "@maria"},
    {"name": "Carlos Lima", "email": "carlos@email.com", "username": "@carlos"},
    {"name": "Ana Pereira", "email": "ana@email.com", "username": "@ana"},
    {"name": "Rafael Costa", "email": "rafael@email.com", "username": "@rafael"},
    {"name": "Fernanda Lima", "email": "fernanda@email.com", "username": "@fernanda"},
    {"name": "Paulo Mendes", "email": "paulo@email.com", "username": "@paulo"},
    {"name": "Juliana Castro", "email": "juliana@email.com", "username": "@juliana"},
    {"name": "Lucas Nunes", "email": "lucas@email.com", "username": "@lucas"},
    {"name": "Vanessa Martins", "email": "vanessa@email.com", "username": "@vanessa"},
  ];

  @override
  void initState() {
    super.initState();
    _loadContacts();
    filteredUsers = allUsers;
  }

  /// 🔹 Carrega os contatos da rede segura salvos no SharedPreferences
  Future<void> _loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedContacts = prefs.getString("safe_network_users");

    if (savedContacts != null) {
      List<dynamic> decodedList = json.decode(savedContacts);
      setState(() {
        contacts = decodedList.map((item) => Map<String, String>.from(item)).toList();
      });
    }

    // 🔹 Adiciona o usuário fixo "Edson Silva" caso ainda não esteja na lista
    bool edsonExists = contacts.any((contact) => contact["username"] == "@edson");
    if (!edsonExists) {
      setState(() {
        contacts.add({
          "name": "Edson Silva",
          "email": "edson@email.com",
          "username": "@edson",
          "status": "accepted", // 🔹 Já aceitou o convite
        });
      });
      _saveContacts();
    }
  }

  /// 🔹 Salva a lista de contatos no SharedPreferences
  Future<void> _saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("safe_network_users", json.encode(contacts));
  }

  /// 🔹 Filtra os usuários ao digitar na busca
  void _filterUsers(String query) {
    setState(() {
      filteredUsers = allUsers
          .where((user) =>
      user["name"]!.toLowerCase().contains(query.toLowerCase()) ||
          user["username"]!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  /// 🔹 Adiciona um usuário à rede segura
  void _addUserToNetwork(Map<String, String> user) {
    setState(() {
      contacts.add({...user, "status": "pending"});
    });
    _saveContacts();
  }

  /// 🔹 Remove um usuário da rede segura
  void _removeUserFromNetwork(Map<String, String> user) {
    setState(() {
      contacts.removeWhere((contact) => contact["username"] == user["username"]);
    });
    _saveContacts();
  }

  /// 🔹 Obtém o ícone correspondente ao status do usuário
  Icon _getStatusIcon(String status) {
    switch (status) {
      case "accepted":
        return Icon(Icons.check_circle, color: Colors.green);
      case "pending":
        return Icon(Icons.hourglass_empty, color: Colors.orange);
      case "rejected":
        return Icon(Icons.cancel, color: Colors.red);
      default:
        return Icon(Icons.help_outline, color: Colors.grey);
    }
  }

  /// 🔹 Exibe um modal para confirmar adição de usuário
  void _showAddUserDialog(Map<String, String> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Adicionar Usuário"),
        content: Text("Deseja adicionar ${user['name']} à sua lista segura?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              _addUserToNetwork(user);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${user['name']} adicionado à sua rede segura!")),
              );
            },
            child: Text("Adicionar"),
          ),
        ],
      ),
    );
  }

  /// 🔹 Exibe um modal para confirmar remoção de usuário
  void _showRemoveUserDialog(Map<String, String> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Remover Usuário"),
        content: Text("Deseja remover ${user['name']} da sua lista segura?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              _removeUserFromNetwork(user);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${user['name']} removido da sua rede segura!")),
              );
            },
            child: Text("Remover"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool canAddMoreUsers = contacts.length < maxContacts;

    return Scaffold(
      appBar: AppBar(
        title: Text("Minha Rede Segura"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Seu plano permite adicionar até $maxContacts pessoas à sua rede segura.",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            SizedBox(height: 10),

            if (canAddMoreUsers)
              Autocomplete<Map<String, String>>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<Map<String, String>>.empty();
                  }
                  return filteredUsers
                      .where((user) =>
                  user["name"]!.toLowerCase().contains(textEditingValue.text.toLowerCase()) ||
                      user["username"]!.toLowerCase().contains(textEditingValue.text.toLowerCase()))
                      .toList();
                },
                displayStringForOption: (user) => user["name"]!,
                onSelected: (user) {
                  _showAddUserDialog(user);
                },
                fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    style: TextStyle(color: Colors.white), // 🔹 Texto visível no modo escuro
                    decoration: InputDecoration(
                      labelText: "Buscar usuário ou e-mail",
                      labelStyle: TextStyle(color: Colors.white70), // 🔹 Cor do placeholder ajustada
                      prefixIcon: Icon(Icons.search, color: Colors.white54), // 🔹 Ícone ajustado
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onChanged: _filterUsers,
                  );
                },
              ),
            SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return ListTile(
                    leading: _getStatusIcon(contact["status"]!),
                    title: Text(contact["name"]!),
                    subtitle: Text(contact["email"]!),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _showRemoveUserDialog(contact);
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
