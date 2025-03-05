import 'package:flutter/material.dart';

class HelpContactWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.phone, color: Colors.green),
        SizedBox(width: 10),
        Text(
          '¿Necesitas ayuda? Llama al ',
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
          ),
        ),
        Text(
          '73247035',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}
