import 'package:flutter/material.dart';
import 'package:control_gastos/screens/login_screen.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isAuthenticated;
  final VoidCallback appLockCallback;

  MyAppBar({required this.isAuthenticated, required this.appLockCallback});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 16),
          Image.asset(
            'assets/logo.png',
            height: 44,
          ),
          Spacer(), // Espacio flexible entre el logo y el texto
          Text(
            'Control de Gastos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(), // Espacio flexible entre el texto y el icono de candado
          Padding(
            padding: const EdgeInsets.only(
                left:
                    10.0), // Ajustar el espacio a la izquierda del icono de candado
            child: IconButton(
              icon: Icon(
                isAuthenticated ? Icons.lock_open : Icons.lock,
                color: const Color.fromARGB(255, 251, 217, 27),
                size: 32.0,
              ),
              onPressed: isAuthenticated
                  ? () {
                      appLockCallback(); // Cierra la sesión
                      _navigateToLoginScreenWithAnimation(
                          context); // Navega a la pantalla de inicio de sesión con animación
                    }
                  : () {
                      _navigateToLoginScreenWithAnimation(
                          context); // Si no está autenticado, también navega a la pantalla de inicio de sesión
                    },
            ),
          ),
        ],
      ),
      iconTheme: IconThemeData(color: Colors.black),
    );
  }

  void _navigateToLoginScreenWithAnimation(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        transitionDuration:
            Duration(milliseconds: 600), // Duración de la transición
        pageBuilder: (_, __, ___) =>
            LoginScreen(), // Construye la pantalla de inicio de sesión
        transitionsBuilder: (_, animation, __, child) {
          // Aplica una transición personalizada
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
      (route) => false, // Bloquea la aplicación
    );
  }
}
