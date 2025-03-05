import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int currentPage;
  final Function(int) onPageSelected;

  const BottomNavigation({
    required this.currentPage,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex: currentPage,
      onTap: onPageSelected,
      items: [
        BottomNavigationBarItem(
          icon: currentPage == 0 ? Icon(Icons.home) : Icon(Icons.home_outlined),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: currentPage == 1
              ? Icon(Icons.monetization_on)
              : Icon(Icons.monetization_on_outlined),
          label: 'Gastos',
        ),
        BottomNavigationBarItem(
          icon: currentPage == 2
              ? Icon(Icons.date_range)
              : Icon(Icons.date_range_outlined),
          label: 'Informes',
        ),
        BottomNavigationBarItem(
          icon: currentPage == 3
              ? Icon(Icons.more_horiz)
              : Icon(Icons.more_horiz_outlined),
          label: 'Más',
        ),
      ],
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Color.fromARGB(255, 82, 81, 81),
      selectedFontSize: 14,
      unselectedFontSize: 14,
      iconSize: 24,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedIconTheme: IconThemeData(),
    );
  }
}
