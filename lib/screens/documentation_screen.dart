import 'package:flutter/material.dart';

class DocumentationScreen extends StatelessWidget {
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
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionCard('Bienvenida', '''
¡Bienvenido a la Aplicación de Control de Gastos! Esta aplicación está diseñada para ayudarte a gestionar y rastrear tus gastos de manera eficiente. A continuación, encontrarás una guía paso a paso sobre cómo utilizar todas las funcionalidades de la aplicación.
'''),
            _buildSectionCard('Registro e Inicio de Sesión', '''
1. Registrarse:
- Abre la aplicación y pulsa en "Ingresar".
- Introduce tu nombre completo, cédula de identidad y el número de celular.
- Pulsa en "Continuar".

2. Verificar pin de seguridad:
- Genere el pin de seguridad de acceso de 6 dígitos pulsando en "Generar PIN de seguridad".
- Ingrese el pin de seguridad de 6 dígitos.
- Pulsa en "Verificar".

3. Inicio de sesión
- Pulsa en usar el sensor de huella, para activar o desactivar el uso de seguridad biometrica gestionada por su dispositivo si presenta algun problema se solicitará el pin de seguridad.
- Pulsa en "Empezar".
- Al pulsar en Empezar será direccionado a la pantalla de Inicio, con esto ya abrá "iniciado la sesión".
'''),
            _buildSectionCard('Navegación Principal', '''
Al estar dentro de la app, vera la pantalla principal de la aplicación. Aquí puedes acceder a las principales funciones:
- Inicio: se visualiza el nombre del usuario registrado, El monto Total de gasto.
- Gastos, Informes, Más.
- También puede ir a Resumen de gastos, Gestionar categorías y Actualizar datos de perfil.
'''),
            _buildSectionCard('Registrar un Gasto', '''
1. Pulsa en el botón "+" para registrar Gastos.
2. Introduce la información del gasto:
- Imagen: Captura o elige la Imagen del gasto.
- Descripción: Descripción breve del gasto.
- Monto: Introduce el monto del gasto.
- Categoría: Seleccionar una categoría para el gasto, si no existe la categoría que busca, puede agregar uno nuevo.
- Fecha y Hora: Selecciona la fecha y hora en la que se realizó el gasto.
3. Pulsa en "Registrar gasto".
'''),
            _buildSectionCard('Editar un Gasto', '''
1. Accede a la sección "Gastos" desde el menú principal.
2. Pulsa en el icono lapiz para editar gasto en específico.
3. Actualizar la información del gasto:
- Descripción: Descripción breve del gasto.
- Monto: Introduce el monto del gasto.
- Categoría: Seleccionar una categoría para el gasto, si no existe la categoría que busca, puede agregar uno nuevo.
- Fecha y Hora: Selecciona la fecha y hora en la que se realizó el gasto.
4. Pulsa en "Guardar cambios".
'''),
            _buildSectionCard('Eliminar un Gasto', '''
1. Accede a la sección "Gastos" desde el menú principal.
2. Pulsa en el icono rojo para eliminar gasto en específico.
- se abrirá un dialog, tendrá que confirmar par aeliminar el gasto.
'''),
            _buildSectionCard('Registrar Categoría', '''
1. Desde el menú principal pulsa en Gestionar categorías.
2. Pulsa en icono "+" para registra categoría.
- Introduce el nombre de la categoría:
3. Pulsa en "Guardar".
'''),
            _buildSectionCard('Editar Categoría', '''
1. Desde el menú principal pulsa en Gestionar categorías.
2. Pulsa en icono lapiz para editar categoría en específico.
- Actualiza el nombre de la categoría:
3. Pulsa en "Guardar".
'''),
            _buildSectionCard('Eliminar Categoría', '''
1. Desde el menú principal pulsa en Gestionar categorías.
2. Pulsa en icono rojo para eliminar categoría en específico.
- se abrirá un dialog, tendrá que confirmar para eliminar, si la categoría a eliminar tiene vinculación con gastos, no podrá eliminar la "categoria".
'''),
            _buildSectionCard('Informe de Gastos', '''
1. Desde el menú principal pulsa en "Resumen de gastos".
2. Aquí puedes ver la información de gastos por:
- Gastos Semanales.
- Gastos Mensuales.
- Gastos Anuales.
- Filtrar por Fecha Personalizada.
'''),
            _buildSectionCard('Resumen de Gastos', '''
1. Desde el menú principal pulsa en "Resumen de gastos".
2. Aquí verás:
- Gráfico en Barras: Representa tus gastos por categoría.
- El monto total de gastos registrados por categoría.
'''),
            _buildSectionCard('Más opciones', '''
1. Desde el menú principal pulsa en "Más".
2. Aquí puedes:
- Modificar Pin de seguridad.
- Activar o desactivar para "Usar el sensor de huella".
- Exportar tus gastos a un archivo CSV.
- Cerrar sesión
'''),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, String content) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              content,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
