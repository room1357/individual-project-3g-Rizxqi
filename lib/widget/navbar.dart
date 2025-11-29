// lib/widgets/custom_bottom_navbar.dart
import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const Navbar({Key? key, required this.currentIndex, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // BottomAppBar with a notch so the FAB can be centered/docked
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      color: Colors.white,
      elevation: 8,
      child: SizedBox(
        height: 64,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Left side: Home and Statistics (Home moved back into navbar)
            Row(
              children: [
                IconButton(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  onPressed: () => onTap(0),
                  icon: Icon(
                    currentIndex == 0 ? Icons.home : Icons.home_outlined,
                    color:
                        currentIndex == 0
                            ? const Color(0xFF6C63FF)
                            : Colors.grey[400],
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  onPressed: () => onTap(1),
                  icon: Icon(
                    currentIndex == 1
                        ? Icons.bar_chart
                        : Icons.bar_chart_outlined,
                    color:
                        currentIndex == 1
                            ? const Color(0xFF6C63FF)
                            : Colors.grey[400],
                  ),
                ),
              ],
            ),

            // Spacer for FAB (wider to avoid cramped icons)
            const SizedBox(width: 80),

            // Right side (2 items) with spacing
            Row(
              children: [
                IconButton(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  onPressed: () => onTap(2),
                  icon: Icon(
                    currentIndex == 2
                        ? Icons.receipt_long
                        : Icons.receipt_long_outlined,
                    color:
                        currentIndex == 2
                            ? const Color(0xFF6C63FF)
                            : Colors.grey[400],
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  onPressed: () => onTap(3),
                  icon: Icon(
                    currentIndex == 3 ? Icons.person : Icons.person_outline,
                    color:
                        currentIndex == 3
                            ? const Color(0xFF6C63FF)
                            : Colors.grey[400],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
