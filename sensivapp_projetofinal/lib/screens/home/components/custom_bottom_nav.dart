import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color activeIconColor = const Color(0xFF7553F6);
    final Color inActiveIconColor =
        isDark ? Colors.white38 : const Color(0xFFB6B6B6);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -5),
            blurRadius: 20,
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              Icons.home_rounded,
              0,
              activeIconColor,
              inActiveIconColor,
            ),
            _buildNavItem(
              Icons.queue_music_rounded,
              1,
              activeIconColor,
              inActiveIconColor,
            ),
            _buildNavItem(
              Icons.edit_note_rounded,
              2,
              activeIconColor,
              inActiveIconColor,
            ),
            _buildNavItem(
              Icons.person_rounded,
              3,
              activeIconColor,
              inActiveIconColor,
            ),
            _buildNavItem(
              Icons.menu_rounded,
              4,
              activeIconColor,
              inActiveIconColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    int index,
    Color activeColor,
    Color inactiveColor,
  ) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemSelected(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 28,
            color: isSelected ? activeColor : inactiveColor,
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 4,
            width: isSelected ? 4 : 0,
            decoration: BoxDecoration(
              color: activeColor,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
