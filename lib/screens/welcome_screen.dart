import 'package:control_gastos/screens/documentation_screen.dart';
import 'package:control_gastos/widgets/help_contact.dart';
import 'package:control_gastos/screens/register_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Contenido de la pantalla de inicio
                Column(
                  children: [
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/logo.png', // Asegúrate de tener el logo en esta ruta
                          height: 40,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Control de Gastos',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Image.asset(
                      'assets/illustration.png', // Asegúrate de tener la ilustración en esta ruta
                      height: 300,
                    ),
                    SizedBox(height: 10),
                    RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontFamily: 'Poppins'),
                        children: [
                          TextSpan(text: 'Bienvenido a '),
                          TextSpan(
                            text: 'Control de Gastos',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              text:
                                  ', la aplicación que te ayuda a llevar un registro de tus gastos y administrar tus finanzas personales.'),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(
                                milliseconds: 600), // Duración de la animación
                            pageBuilder: (_, __, ___) =>
                                RegisterScreen(), // Página de destino
                            transitionsBuilder: (_, animation, __, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: Offset(
                                      -1.0, 0.0), // Empieza desde la izquierda
                                  end: Offset
                                      .zero, // Termina en la posición actual
                                ).animate(animation),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        textStyle: TextStyle(fontSize: 20),
                        backgroundColor: Color.fromARGB(255, 57, 52, 66),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.login,
                            color: Color.fromARGB(255, 6, 206, 178),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Ingresar',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Poppins'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(
                                milliseconds:
                                    600), // Ajusta la duración de la transición
                            pageBuilder: (_, __, ___) =>
                                DocumentationScreen(), // Construye la pantalla de DocumentationScreen
                            transitionsBuilder: (_, animation, __, child) {
                              // Aplica una transición personalizada
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: Offset(0, 1), // Inicia desde abajo
                                  end:
                                      Offset.zero, // Hasta la posición original
                                ).animate(animation),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: Text(
                        'Guía del usuario',
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    HelpContactWidget(),
                    SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
