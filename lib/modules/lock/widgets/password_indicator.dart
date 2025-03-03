import 'package:flutter/material.dart';

class PasswordIndicator extends StatelessWidget {
  final String enteredPassword;

  PasswordIndicator(this.enteredPassword);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 8),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: index < enteredPassword.length ? Colors.white : Colors.grey,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
