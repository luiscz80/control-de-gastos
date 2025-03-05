import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:
            false, // Elimina el botón de retroceso predeterminado
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.black,
            ),
            iconSize: 34, // Establece el tamaño del icono
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 80,
                ),
                SizedBox(height: 0),
                Text(
                  'APP Control de Gastos',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 0),
                Text(
                  'Versión 2.1.0',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 10),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildDescription(),
                  ),
                ),
                SizedBox(height: 8),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      children: [
                        Text(
                          'Síguenos en:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildContactIconButton(Icons.facebook, null),
                            _buildContactIconButton(Icons.tiktok, null),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      _appDescription,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: 14,
      ),
    );
  }

  Widget _buildContactIconButton(IconData icon, VoidCallback? onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 40,
        color: Colors.blue,
      ),
    );
  }
}

const String _appDescription = '''
La aplicación de control de gastos es una herramienta indispensable para aquellos que desean administrar sus finanzas de manera eficiente y mantener un seguimiento detallado de sus gastos. Diseñada con una interfaz intuitiva y amigable, esta aplicación ofrece una solución completa para gestionar el presupuesto personal o familiar, brindando a los usuarios el control total sobre sus actividades financieras.

Características Principales:

Registro de Gastos: Permite a los usuarios registrar fácilmente sus gastos diarias, con la opción de categorizar cada gasto para un análisis más detallado.

Análisis y Estadísticas: Proporciona herramientas poderosas para analizar los hábitos de gasto y visualizar datos financieros mediante gráficos interactivos y detallados, que muestran la distribución del gasto por categoría.

Seguridad y Privacidad: Garantiza la seguridad de los datos financieros de los usuarios mediante la implementación de medidas de seguridad avanzadas, como el cifrado de datos y la autenticación de dos factores y huella dactilar, para proteger la información personal y financiera.

Sincronización: Ofrece la posibilidad de sincronizar los datos en tu dispositivo, para acceder a la información financiera en cualquier momento y lugar.

Beneficios:

Control total sobre las finanzas personales y familiares.
Mejora en la toma de decisiones financieras mediante análisis detallados.
Ahorro de tiempo y esfuerzo en la gestión y seguimiento de gastos.
Mayor conciencia y responsabilidad en el manejo del dinero.
Paz mental y seguridad financiera a largo plazo.

Conclusión:

La aplicación de control de gastos es una herramienta imprescindible para aquellos que desean llevar un estilo de vida financiero saludable y responsable. Con sus características avanzadas y su enfoque en la facilidad de uso y la seguridad, esta aplicación se convierte en un aliado confiable para alcanzar metas financieras y tomar el control de las finanzas personales de manera efectiva.
''';
