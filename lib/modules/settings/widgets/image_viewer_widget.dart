import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ImageViewerWidget extends StatefulWidget {
  final String imageUrl;

  ImageViewerWidget({required this.imageUrl});

  @override
  _ImageViewerWidgetState createState() => _ImageViewerWidgetState();
}

class _ImageViewerWidgetState extends State<ImageViewerWidget> {
  bool _isFullScreen = false;

  /// 🔹 Baixa a imagem e salva localmente
  Future<void> _downloadImage() async {
    try {
      final response = await http.get(Uri.parse(widget.imageUrl));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = "${directory.path}/downloaded_image.png";
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Imagem baixada com sucesso!")),
        );
      } else {
        throw Exception("Falha ao baixar a imagem");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao baixar imagem: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _isFullScreen = !_isFullScreen);
      },
      child: _isFullScreen
          ? Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: PhotoViewGallery.builder(
                itemCount: 1,
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(widget.imageUrl),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 2,
                  );
                },
                scrollPhysics: BouncingScrollPhysics(),
                backgroundDecoration: BoxDecoration(color: Colors.black),
              ),
            ),
            Positioned(
              top: 40,
              right: 10,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => setState(() => _isFullScreen = false),
              ),
            ),
          ],
        ),
      )
          : Column(
        children: [
          Expanded(
            child: Image.network(widget.imageUrl, fit: BoxFit.cover),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.fullscreen, color: Colors.blueAccent),
                onPressed: () => setState(() => _isFullScreen = true),
              ),
              IconButton(
                icon: Icon(Icons.download, color: Colors.blueAccent),
                onPressed: _downloadImage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
