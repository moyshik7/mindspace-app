import 'package:flutter/material.dart';
import '../core/widgets/glass_bottom_nav.dart';

class AppShell extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;
  final Widget child;

  const AppShell({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      extendBody: true,
      bottomNavigationBar: GlassBottomNav(
        currentIndex: currentIndex,
        onTap: onTabChanged,
      ),
    );
  }
}
