import 'package:flutter/material.dart';
import '../styles/bottom_nav_styles.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate responsive heights
    final navBarHeight = screenHeight * 0.08; // 8% of screen height
    final totalHeight = navBarHeight + bottomPadding;
    final itemHeight = navBarHeight * 0.7; // 70% of nav bar height

    return Container(
      height: totalHeight,
      decoration: BottomNavStyles.navDecoration,
      child: BottomAppBar(
        elevation: 0,
        color: Colors.transparent,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: SizedBox(
            height: navBarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: SizedBox(
                    height: itemHeight,
                    child: _buildNavItem(0, Icons.menu, 'Menu'),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: itemHeight,
                    child: _buildNavItem(1, Icons.search, 'Search'),
                  ),
                ),
                const Expanded(child: SizedBox()), // FAB space
                Expanded(
                  child: SizedBox(
                    height: itemHeight,
                    child: _buildNavItem(2, Icons.notifications_none, 'Alerts'),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: itemHeight,
                    child: _buildNavItem(3, Icons.person_outline, 'Profile'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = currentIndex == index;

    return LayoutBuilder(
      builder: (context, constraints) {
        final iconSize = constraints.maxHeight * 0.4;
        final fontSize = constraints.maxHeight * 0.2;

        return InkWell(
          onTap: () => onTap(index),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: BottomNavStyles.getIconColor(isActive),
                size: iconSize,
              ),
              SizedBox(height: constraints.maxHeight * 0.1),
              Text(
                label,
                style: BottomNavStyles.getTextStyle(isActive).copyWith(
                  fontSize: fontSize,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}
