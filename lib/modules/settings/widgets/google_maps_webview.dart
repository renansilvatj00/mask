import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GoogleMapsWebView extends StatefulWidget {
  final String latitude;
  final String longitude;

  GoogleMapsWebView({required this.latitude, required this.longitude});

  @override
  _GoogleMapsWebViewState createState() => _GoogleMapsWebViewState();
}

class _GoogleMapsWebViewState extends State<GoogleMapsWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(
          "https://maps.google.com/maps?q=${widget.latitude},${widget.longitude}&z=15",
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mapa - Localização")),
      body: WebViewWidget(controller: _controller),
    );
  }
}

