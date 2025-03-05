import 'package:control_gastos/screens/add_expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:control_gastos/providers/users_provider.dart';
import 'package:control_gastos/screens/expense_list_screen.dart';
import 'package:control_gastos/screens/information_expense_screen.dart';
import 'package:control_gastos/screens/reports_screen.dart';
import 'package:control_gastos/screens/settings_screen.dart';
import 'package:control_gastos/widgets/app_bar.dart';
import 'package:control_gastos/widgets/bottom_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  void _appBlock() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UsersProvider>(
      builder: (context, usersProvider, _) {
        bool isAuthenticated = usersProvider.isAuthenticated;

        return WillPopScope(
          onWillPop: () async => true, // Bloquear retroceso
          child: Scaffold(
            body: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: MyAppBar(
                      isAuthenticated: isAuthenticated,
                      appLockCallback: _appBlock,
                    ),
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: [
                      InformationExpenseScreen(),
                      ExpenseListScreen(),
                      ReportsScreen(),
                      SettingsScreen(),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigation(
              currentPage: _currentPage,
              onPageSelected: (int page) {
                setState(() {
                  _currentPage = page;
                  _pageController.jumpToPage(page);
                });
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration:
                        Duration(milliseconds: 600), // Duración de la animación
                    pageBuilder: (_, __, ___) =>
                        AddExpenseScreen(), // Página de destino
                    transitionsBuilder: (_, animation, __, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0.0, 1.0), // Empieza desde abajo
                          end: Offset.zero, // Termina en la posición actual
                        ).animate(animation),
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: Icon(Icons.add, color: Colors.white),
              backgroundColor: Color.fromARGB(255, 6, 206, 178),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    30), // Ajusta el valor según desees el redondeo
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          ),
        );
      },
    );
  }
}
