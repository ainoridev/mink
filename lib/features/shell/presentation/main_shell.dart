import "package:flutter/material.dart";
import "package:phosphor_flutter/phosphor_flutter.dart";

import "package:mink/features/home/presentation/home_page.dart";
import "package:mink/features/settings/presentation/settings_page.dart";
import "package:mink/features/shop/presentation/shop_page.dart";

/// Layout principal autenticado con navegación inferior.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 1;

  static const _destinations = [
    _ShellDestination(
      label: "Tienda",
      icon: PhosphorIconsRegular.shoppingBag,
      selectedIcon: PhosphorIconsFill.shoppingBag,
    ),
    _ShellDestination(
      label: "Main",
      icon: PhosphorIconsRegular.brain,
      selectedIcon: PhosphorIconsFill.brain,
    ),
    _ShellDestination(
      label: "Perfil",
      icon: PhosphorIconsRegular.user,
      selectedIcon: PhosphorIconsFill.user,
    ),
  ];

  static const _pages = [
    ShopPage(),
    HomePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: [
          for (final destination in _destinations)
            NavigationDestination(
              icon: Icon(destination.icon),
              selectedIcon: Icon(destination.selectedIcon),
              label: destination.label,
            ),
        ],
      ),
    );
  }
}

class _ShellDestination {
  const _ShellDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
