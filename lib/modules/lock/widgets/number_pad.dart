import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NumberPad extends StatelessWidget {
  final Function(String) onNumberTap;
  final VoidCallback onClear;
  final VoidCallback onBack;

  NumberPad({required this.onNumberTap, required this.onClear, required this.onBack});

  Widget _buildNumberButton(String number, int index) {
    return Animate(
      effects: [FadeEffect(duration: Duration(milliseconds: 300 * (index + 1)))],
      child: GestureDetector(
        onTap: () => onNumberTap(number),
        child: Container(
          width: 80,
          height: 80,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[700],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(icon, color: Colors.white, size: 30),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9"];

    return Column(
      children: [
        for (var i = 0; i < numbers.length; i += 3)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildNumberButton(numbers[i], i),
              _buildNumberButton(numbers[i + 1], i + 1),
              _buildNumberButton(numbers[i + 2], i + 2),
            ],
          ),
        
        // 📌 Última linha com os botões "Voltar", "0" e "Limpar"
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildActionButton(Icons.arrow_back, onBack, Colors.blueAccent), // Botão de voltar
            _buildNumberButton("0", 9), // Número "0" no centro
            _buildActionButton(Icons.clear, onClear, Colors.redAccent), // Botão de limpar
          ],
        ),
      ],
    );
  }
}
