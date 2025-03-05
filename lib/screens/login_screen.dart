import 'package:control_gastos/providers/users_provider.dart';
import 'package:control_gastos/widgets/app_bar.dart';
import 'package:control_gastos/widgets/help_contact.dart';
import 'package:control_gastos/screens/remember_pin_screen.dart';
import 'package:control_gastos/widgets/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';

import 'package:control_gastos/screens/home_screen.dart';
import 'package:control_gastos/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalAuthentication localAuth = LocalAuthentication();
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    // Cargar la preferencia del switch al iniciar la pantalla
    Provider.of<AuthProvider>(context, listen: false).loadPreference();
  }

  void _appBlock() {
    setState(() {
      _isAuthenticated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool useBiometrics = Provider.of<AuthProvider>(context).useBiometrics;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: MyAppBar(
                        isAuthenticated: _isAuthenticated,
                        appLockCallback: _appBlock,
                      ),
                    ),
                  ),
                  SizedBox(height: 180),
                  Image.asset(
                    'assets/lock.png',
                    height: 120,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _isAuthenticated
                        ? null
                        : () => _authenticate(useBiometrics, context),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      textStyle: TextStyle(fontSize: 20),
                      backgroundColor: Color.fromARGB(255, 57, 52, 66),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: _isAuthenticated
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.lock,
                                color: Color.fromARGB(255, 6, 206, 178),
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Desbloquear',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'Poppins'),
                              ),
                            ],
                          ),
                  ),
                  SizedBox(height: 20),
                  Text("Usa tu pin de seguridad"),
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
                              RememberPinScreen(), // Construye la pantalla de RememberPinScreen
                          transitionsBuilder: (_, animation, __, child) {
                            // Aplica una transición personalizada
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: Offset(0, 1), // Inicia desde abajo
                                end: Offset.zero, // Hasta la posición original
                              ).animate(animation),
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: Text(
                      '¿No recuerdas tu pin?',
                      style: TextStyle(
                          fontSize: 15, color: Theme.of(context).primaryColor),
                    ),
                  ),
                  SizedBox(height: 40),
                  HelpContactWidget(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _authenticate(bool useBiometrics, BuildContext context) async {
    setState(() {
      _isAuthenticated = true;
    });

    bool isAuthenticated = false;

    if (useBiometrics) {
      try {
        isAuthenticated = await localAuth.authenticate(
          localizedReason: 'Por favor, autentícate para continuar en la APP',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );
      } catch (e) {
        showCustomSnackBar(context, 'Error de autenticación biométrica.');
      }
    }

    if (!isAuthenticated) {
      isAuthenticated = await _requestPIN(context);
    }

    if (isAuthenticated) {
      _navigateToHomeScreenWithAnimation();
    } else {
      setState(() {
        _isAuthenticated = false;
      });
    }
  }

  Future<bool> _requestPIN(BuildContext context) async {
    while (true) {
      String? pin = await _showInputDialog();

      if (pin == null) return false;

      final usersProvider = Provider.of<UsersProvider>(context, listen: false);
      await usersProvider
          .fetchUserData(); // Asegúrate de que el método se llame fetchUser

      // Obtén el pin almacenado del usuario
      final storedPin = usersProvider.users.isNotEmpty
          ? usersProvider.users.first.code
          : null;

      if (storedPin != null && pin == storedPin) {
        return true;
      } else {
        showCustomSnackBar(context, 'El PIN de acceso es incorrecto.');
      }
    }
  }

  Future<String?> _showInputDialog() async {
    TextEditingController _textFieldController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'El pin de seguridad',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _textFieldController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Número de 6 dígitos',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, _textFieldController.text);
              },
              child: Text(
                'Aceptar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _navigateToHomeScreenWithAnimation() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration:
            Duration(milliseconds: 600), // Duración de la transición
        pageBuilder: (_, __, ___) =>
            HomeScreen(), // Construye la pantalla de HomeScreen
        transitionsBuilder: (_, animation, __, child) {
          // Aplica una transición personalizada
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}
