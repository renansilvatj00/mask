import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask/modules/settings/widgets/audio_player_widget.dart';
import 'package:mask/modules/settings/widgets/google_maps_webview.dart';
import 'package:mask/modules/settings/widgets/image_viewer_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class PanicTimelineScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, String>? user = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;

    // 🔹 Lista de eventos simulada
    final List<Map<String, dynamic>> events = [
      {
        "title": "📍 Localização enviada",
        "description": "Usuário enviou sua localização.",
        "latitude": "-23.5505",
        "longitude": "-46.6333",
        "timestamp": DateTime.now().subtract(Duration(minutes: 10)),
      },
      {
        "title": "🎤 Áudio gravado",
        "description": "Ouça o áudio gravado.",
        "audioUrl": "https://onlinetestcase.com/wp-content/uploads/2023/06/100-KB-MP3.mp3",
        "timestamp": DateTime.now().subtract(Duration(minutes: 8)),
      },
      {
        "title": "📷 Foto capturada",
        "description": "Visualizar imagem capturada.",
        "photoUrl": "https://i.imgur.com/aowx6nx.png",
        "timestamp": DateTime.now().subtract(Duration(minutes: 6)),
      },
      {
        "title": "🔴 Modo Pânico ativado",
        "description": "Usuário ativou o modo pânico.",
        "timestamp": DateTime.now().subtract(Duration(minutes: 12)),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(user != null ? "Eventos de ${user['name']}" : "Eventos de Pânico"),
      ),
      body: user != null
          ? _buildTimeline(user, events)
          : Center(
        child: Text(
          "Nenhum usuário selecionado!",
          style: TextStyle(fontSize: 18, color: Colors.red),
        ),
      ),
    );
  }

  /// 🔹 Constrói a timeline dos eventos do usuário
  Widget _buildTimeline(Map<String, String> user, List<Map<String, dynamic>> events) {
    if (events.isEmpty) {
      return Center(
        child: Text(
          "Nenhum evento disponível!",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return _buildEventItem(context, event);
      },
    );
  }

  /// 🔹 Cria um item de evento da timeline
  Widget _buildEventItem(BuildContext context, Map<String, dynamic> event) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(event["title"] ?? "Evento desconhecido", style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event["description"] ?? ""),
            if (event.containsKey("timestamp"))
              Text(
                "Horário: ${DateFormat('HH:mm - dd/MM/yyyy').format(event["timestamp"])}",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ],
        ),
        leading: Icon(Icons.event, color: Colors.blueAccent),
        trailing: _buildDownloadButton(event),
        onTap: () {
          _handleEventTap(context, event);
        },
      ),
    );
  }

  /// 🔹 Cria um botão de download quando houver áudio ou imagem no evento
  Widget _buildDownloadButton(Map<String, dynamic> event) {
    if (event.containsKey("audioUrl")) {
      return IconButton(
        icon: Icon(Icons.download, color: Colors.blue),
        onPressed: () => _downloadFile(event["audioUrl"], "audio.mp3"),
      );
    } else if (event.containsKey("photoUrl")) {
      return IconButton(
        icon: Icon(Icons.download, color: Colors.blue),
        onPressed: () => _downloadFile(event["photoUrl"], "image.png"),
      );
    }
    return SizedBox(); // Se não houver download, não exibe nada
  }

  /// 🔹 Função para baixar arquivos e salvar localmente
  Future<void> _downloadFile(String url, String fileName) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = "${directory.path}/$fileName";
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        print("✅ Arquivo salvo em: $filePath");
      } else {
        print("⚠️ Falha ao baixar o arquivo.");
      }
    } catch (e) {
      print("❌ Erro ao baixar o arquivo: $e");
    }
  }


  /// 🔹 Lida com cliques nos eventos da timeline
  void _handleEventTap(BuildContext context, Map<String, dynamic> event) {
    if (event.containsKey("latitude") && event.containsKey("longitude")) {
      _showLocationModal(context, event["latitude"], event["longitude"]);
    } else if (event.containsKey("audioUrl")) {
      _showAudioPlayer(context, event["audioUrl"]);
    } else if (event.containsKey("photoUrl")) {
      _showPhotoModal(context, event["photoUrl"]);
    }
  }

  /// 🔹 Exibe um modal com a localização
  void _showLocationModal(BuildContext context, String latitude, String longitude) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Localização Enviada"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("O usuário enviou sua localização."),
            SizedBox(height: 10),
            Text("📍 Coordenadas: $latitude, $longitude"),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GoogleMapsWebView(latitude: latitude, longitude: longitude),
                  ),
                );
              },
              child: Text("Abrir no Mapa"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Fechar"),
          ),
        ],
      ),
    );
  }

  /// 🔹 Exibe um modal para reprodução de áudio
  void _showAudioPlayer(BuildContext context, String audioUrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Áudio Gravado"),
        content: AudioPlayerWidget(audioUrl: audioUrl),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Fechar"),
          ),
        ],
      ),
    );
  }

  /// 🔹 Exibe um modal para visualizar imagem
  void _showPhotoModal(BuildContext context, String photoUrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Foto Capturada"),
        content: ImageViewerWidget(imageUrl: photoUrl),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Fechar"),
          ),
        ],
      ),
    );
  }
}
