import 'package:control_gastos/models/categories.dart';
import 'package:control_gastos/models/expense.dart';
import 'package:control_gastos/providers/categories_provider.dart';
import 'package:control_gastos/providers/hide_balance_provider.dart';
import 'package:control_gastos/screens/about_us_screen.dart';
import 'package:control_gastos/screens/dashboard_screen.dart';
import 'package:control_gastos/screens/documentation_screen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:control_gastos/screens/category_list_screen.dart';
import 'package:control_gastos/screens/profile_screen.dart';

import 'package:provider/provider.dart';
import '../providers/expenses_provider.dart';
import '../providers/users_provider.dart';

class InformationExpenseScreen extends StatefulWidget {
  const InformationExpenseScreen({super.key});

  @override
  _InformationExpenseScreenState createState() =>
      _InformationExpenseScreenState();
}

class _InformationExpenseScreenState extends State<InformationExpenseScreen> {
  int _currentPage = 0;
  bool _isLoading = true;
  bool showUserData = false;

  @override
  void initState() {
    super.initState();
    _getUserData();
    showUserData = false;
  }

  void _getUserData() async {
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    await usersProvider.fetchUserData();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool hideBalance = Provider.of<HideBalanceProvider>(context).hideBalance;

    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('Cargando datos...',
                      style: TextStyle(
                          fontSize: 16, color: Theme.of(context).primaryColor)),
                ],
              ),
            )
          : Stack(
              children: [
                SingleChildScrollView(
                    child: Column(
                  children: [
                    Container(
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.all(12.0),
                      child: _isLoading
                          ? Center(child: CircularProgressIndicator())
                          : Consumer<UsersProvider>(
                              builder: (context, usersProvider, child) {
                                final user = usersProvider.users.first;
                                return Column(
                                  children: [
                                    Center(
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 25,
                                            backgroundColor:
                                                Colors.grey.shade200,
                                            child: Icon(
                                              Icons.person,
                                              size: 25,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                showUserData =
                                                    !showUserData; // Cambiar el estado para mostrar u ocultar los datos del usuario
                                              });
                                            },
                                            child: Text(
                                              '¡Hola, ${user.name}!',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          if (showUserData)
                                            Column(
                                              children: [
                                                Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.credit_card,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        '${user.cedula}',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 1),
                                                Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.phone,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        '${user.phoneNumber}',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Monto',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (!hideBalance)
                                          _infoExpenseAmount(context),
                                        SizedBox(),
                                        Row(
                                          children: [
                                            hideBalance
                                                ? Text(
                                                    'Ocultar Monto',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  )
                                                : Text(
                                                    'Mostrar Monto',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                            SizedBox(
                                                width:
                                                    0), // Espacio entre el texto y el ícono
                                            IconButton(
                                              icon: hideBalance
                                                  ? Icon(
                                                      Icons
                                                          .visibility_off_outlined,
                                                      color: Colors.white,
                                                    )
                                                  : Icon(
                                                      Icons.visibility_outlined,
                                                      color: Colors.white,
                                                    ),
                                              onPressed: () {
                                                final hideBalanceProvider =
                                                    Provider.of<
                                                            HideBalanceProvider>(
                                                        context,
                                                        listen: false);
                                                setState(() {
                                                  hideBalanceProvider
                                                      .setHideBalance(
                                                          !hideBalanceProvider
                                                              .hideBalance);
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor: Color.fromARGB(
                                                  255, 57, 52, 66),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    10), // Puedes ajustar el radio aquí
                                              ),
                                            ),
                                            icon: Icon(
                                              Icons.person_rounded,
                                              color: Color.fromARGB(255, 6, 206,
                                                  178), // Cambia el color del ícono aquí
                                            ),
                                            label: Text(
                                              'Guía de usuario',
                                              style: TextStyle(
                                                fontSize:
                                                    10, // Puedes ajustar el tamaño del texto aquí
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                  transitionDuration: Duration(
                                                      milliseconds:
                                                          600), // Duración de la transición
                                                  pageBuilder: (_, __, ___) =>
                                                      DocumentationScreen(), // Construye la pantalla de DocumentationScreen
                                                  transitionsBuilder: (_,
                                                      animation, __, child) {
                                                    // Aplica una transición personalizada de izquierda a derecha
                                                    return SlideTransition(
                                                      position: Tween<Offset>(
                                                        begin: Offset(0,
                                                            1), // Comienza desde la izquierda
                                                        end: Offset
                                                            .zero, // Hasta la posición original
                                                      ).animate(animation),
                                                      child: child,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 14),
                                        Flexible(
                                          child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor: Color.fromARGB(
                                                  255, 57, 52, 66),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    10), // Puedes ajustar el radio aquí
                                              ),
                                            ),
                                            icon: Icon(
                                              Icons.phone_android_outlined,
                                              color: Color.fromARGB(255, 6, 206,
                                                  178), // Cambia el color del ícono aquí
                                            ),
                                            label: Text(
                                              'Acerca de app',
                                              style: TextStyle(
                                                fontSize:
                                                    10, // Puedes ajustar el tamaño del texto aquí
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                  transitionDuration: Duration(
                                                      milliseconds:
                                                          600), // Duración de la transición
                                                  pageBuilder: (_, __, ___) =>
                                                      AboutUsScreen(), // Construye la pantalla de AboutUsScreen
                                                  transitionsBuilder: (_,
                                                      animation, __, child) {
                                                    // Aplica una transición personalizada de izquierda a derecha
                                                    return SlideTransition(
                                                      position: Tween<Offset>(
                                                        begin: Offset(0,
                                                            1), // Comienza desde la izquierda
                                                        end: Offset
                                                            .zero, // Hasta la posición original
                                                      ).animate(animation),
                                                      child: child,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                    ),
                    SizedBox(height: 2),
                    _actionButtons(context),
                  ],
                )),
              ],
            ),
    );
  }

  Widget _actionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 8.0, 4.0, 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionBottons(
                  'Resumen de gastos', Icons.analytics_outlined, context),
              _buildActionBottons(
                  'Gestionar categorías', Icons.category_outlined, context),
              _buildActionBottons(
                  'Actualizar datos', Icons.person_outline, context),
            ],
          ),
          SizedBox(height: 14),
          _carouselContent(context),
          _buildTransactionList(context),
        ],
      ),
    );
  }

  Widget _buildActionBottons(
      String title, IconData icon, BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(3.0, 10.0, 10.0, 5.0),
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.white),
            elevation: WidgetStateProperty.all(5),
            shadowColor: WidgetStateProperty.all(Colors.black.withOpacity(0.6)),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          ),
          onPressed: () {
            switch (title) {
              case 'Resumen de gastos':
                _navigateWithTransition(context, DashboardScreen());
                break;
              case 'Gestionar categorías':
                _navigateWithTransition(context, CategoryScreen());
                break;
              case 'Actualizar datos':
                _navigateWithTransition(context, ProfileScreen());
                break;
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.all(12),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateWithTransition(BuildContext context, Widget destination) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => destination,
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  Widget _carouselContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4.0, 0.0, 10.0, 0.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 229, 255, 252),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 60,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 5),
                      enlargeCenterPage: true,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                    ),
                    items: [
                      _buildCarouselItem('assets/slider/expenses.png',
                          '¡Registra tus gastos de manera fácil y sencilla con nuestra intuitiva interfaz!'),
                      _buildCarouselItem('assets/slider/categories.png',
                          '¡Categoriza tus gastos para mantener un control organizado y efectivo de tus finanzas!'),
                      _buildCarouselItem('assets/slider/analitics.png',
                          '¡Visualiza el total de tus gastos según las categorías en gráficos de barra!'),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Color.fromARGB(255, 6, 206, 178)
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoExpenseAmount(BuildContext context) {
    return Consumer<ExpensesProvider>(
      builder: (context, expenseProvider, child) {
        return FutureBuilder<double>(
          future: expenseProvider.getTotalExpenseAmount(),
          builder: (context, snapshot) {
            double totalAmount = snapshot.data ?? 0.0;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Bs. ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: totalAmount.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildCarouselItem(String icon, String text) {
    return SizedBox(
      width: MediaQuery.of(context).size.width, // Ancho del dispositivo
      child: Row(
        children: [
          Image.asset(
            icon,
            width: 40,
            height: 40,
            // Ajusta el ancho y alto de la imagen según tus necesidades
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(3.0, 0.0, 10.0, 5.0),
      child: Row(
        children: [
          Expanded(
            child: Consumer<ExpensesProvider>(
              builder: (context, expenseViewModel, child) {
                if (expenseViewModel.expenses.isEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Gastos recientes',
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: 8), // Agregando un espacio entre los textos
                      Center(
                        child: Text(
                          'Aún no hay registro de gastos',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 16),
                      Text(
                        'Gastos recientes',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: 0),
                      ...List.generate(
                        expenseViewModel.expenses.length,
                        (index) {
                          final int reversedIndex =
                              expenseViewModel.expenses.length - 1 - index;
                          final Expense expense =
                              expenseViewModel.expenses[reversedIndex];
                          final Widget imageWidget = Image.file(
                            expense.imagePath!,
                            width: MediaQuery.of(context)
                                .size
                                .width, // Ajuste del ancho
                            height: 140,
                            fit: BoxFit.cover,
                          );

                          return _buildTransactionItem(
                            imageWidget,
                            Text(
                              expense.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            'Bs. ${expense.amount.toStringAsFixed(2)}',
                            Provider.of<CategoriesProvider>(context,
                                    listen: false)
                                .categories
                                .firstWhere(
                                  (category) =>
                                      category.id == expense.categoryId,
                                  orElse: () =>
                                      Category(id: -1, name: 'No definida'),
                                )
                                .name
                                .toUpperCase(),
                          );
                        },
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
      Widget image, Widget title, String amount, String category) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            contentPadding: EdgeInsets.zero, // Elimina el padding del ListTile
            leading: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.monetization_on_outlined,
                color: Theme.of(context).primaryColor,
              ),
            ),

            title: title,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    '$amount',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(
              0), // Ajusta el espacio interior del contenedor según sea necesario
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 6, 206, 178),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (BuildContext context) {
                  return DraggableScrollableSheet(
                    initialChildSize: 0.5,
                    maxChildSize: 0.5,
                    minChildSize: 0.3,
                    builder: (context, scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 50,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Detalles del Gasto',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 6, 206, 178),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Text(
                                    'Gasto: ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  title,
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'Monto: ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    amount,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'Categoría: ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    category,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    width: 320, // Tamaño reducido de la imagen
                                    height: 200, // Tamaño reducido de la imagen
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child:
                                        image, // La imagen que deseas mostrar
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
            label: const Text(
              'Ver',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
