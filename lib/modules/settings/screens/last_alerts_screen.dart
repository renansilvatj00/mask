import 'package:flutter/material.dart';

class LastAlertsScreen extends StatelessWidget {
  // 🔹 Lista mockada de alertas recentes
  final List<Map<String, dynamic>> alerts = [
    {
      "icon": Icons.person_add,
      "title": "Usuário Adicionado",
      "description": "Usuário João adicionou você em uma lista segura.",
      "timestamp": "Hoje, 10:30 AM"
    },
    {
      "icon": Icons.warning,
      "title": "Modo Pânico Ativado",
      "description": "Usuário Maria ativou o modo pânico por senha falsa.",
      "timestamp": "Hoje, 09:15 AM"
    },
    {
      "icon": Icons.lock_open,
      "title": "Modo Pânico Desativado",
      "description": "Usuário Carlos desativou o modo pânico.",
      "timestamp": "Ontem, 18:40 PM"
    },
    {
      "icon": Icons.credit_card,
      "title": "Pagamento Recusado",
      "description": "Atualize seu método de pagamento para continuar seu plano.",
      "timestamp": "Ontem, 16:20 PM"
    },
    {
      "icon": Icons.calendar_today,
      "title": "Plano Próximo do Vencimento",
      "description": "Seu plano vencerá no dia 25/03. Renove para evitar interrupções.",
      "timestamp": "2 dias atrás"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Últimos Alertas"),
        backgroundColor: Colors.blueAccent,
      ),
      body: _buildAlertList(),
    );
  }

  // 🔹 Constrói a lista de alertas
  Widget _buildAlertList() {
    if (alerts.isEmpty) {
      return Center(
        child: Text(
          "Nenhum alerta recente.",
          style: TextStyle(fontSize: 16, color: Colors.white70),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(10),
      itemCount: alerts.length,
      separatorBuilder: (context, index) => Divider(color: Colors.white30),
      itemBuilder: (context, index) {
        final alert = alerts[index];

        return ListTile(
          leading: Icon(alert["icon"], color: Colors.blueAccent, size: 30),
          title: Text(alert["title"], style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(alert["description"]),
          trailing: Text(alert["timestamp"], style: TextStyle(color: Colors.white54, fontSize: 12)),
        );
      },
    );
  }
}
