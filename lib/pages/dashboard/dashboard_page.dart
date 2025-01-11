import 'package:flutter/material.dart';
import '../../styles/app_styles.dart';
import 'dashboard_styles.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({Key? key}) : super(key: key);

  final List<MenuOption> menuOptions = [
    MenuOption(
      title: 'My Account',
      imagePath: 'assets/images/today.png',
      onTap: () {},
    ),
    MenuOption(
      title: 'Inventory',
      imagePath: 'assets/images/today.png',
      onTap: () {},
    ),
    MenuOption(
      title: 'Search Machine',
      imagePath: 'assets/images/today.png',
      onTap: () {},
    ),
    MenuOption(
      title: 'Request',
      imagePath: 'assets/images/today.png',
      onTap: () {},
    ),
    MenuOption(
      title: 'Analytics',
      imagePath: 'assets/images/today.png',
      onTap: () {},
    ),
    MenuOption(
      title: 'Contact us',
      imagePath: 'assets/images/today.png',
      onTap: () {},
    ),
    MenuOption(
      title: 'Orders',
      imagePath: 'assets/images/today.png',
      onTap: () {},
    ),
    MenuOption(
      title: 'Maintenance',
      imagePath: 'assets/images/today.png',
      onTap: () {},
    ),
    MenuOption(
      title: 'Reports',
      imagePath: 'assets/images/today.png',
      onTap: () {},
    ),
    MenuOption(
      title: 'Settings',
      imagePath: 'assets/images/today.png',
      onTap: () {},
    ),
    MenuOption(
      title: 'Notifications',
      imagePath: 'assets/images/today.png',
      onTap: () {},
    ),
    MenuOption(
      title: 'Schedule',
      imagePath: 'assets/images/today.png',
      onTap: () {},
    ),
    MenuOption(
      title: 'Documents',
      imagePath: 'assets/images/today.png',
      onTap: () {},
    ),
    MenuOption(
      title: 'History',
      imagePath: 'assets/images/today.png',
      onTap: () {},
    ),
    MenuOption(
      title: 'Help',
      imagePath: 'assets/images/today.png',
      onTap: () {},
    ),
    MenuOption(
      title: 'Suppliers',
      imagePath: 'assets/images/today.png',
      onTap: () {},
    ),
    MenuOption(
      title: 'Projects',
      imagePath: 'assets/images/today.png',
      onTap: () {},
    ),
    MenuOption(
      title: 'Teams',
      imagePath: 'assets/images/today.png',
      onTap: () {},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _buildContent(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppStyles.getResponsivePadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                iconSize: 24,
                onPressed: () {},
              ),
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/today.png',
                    height: 32,
                    width: 32,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppStyles.spacing24),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppStyles.spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dashboard',
                  style: AppStyles.h1.copyWith(
                    color: Colors.white,
                    fontSize: AppStyles.getResponsiveFontSize(context, 24),
                  ),
                ),
                SizedBox(height: AppStyles.spacing4),
                Text(
                  'Last Update 25 Feb 2024',
                  style: AppStyles.body2.copyWith(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: AppStyles.getResponsiveFontSize(context, 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      decoration: DashboardStyles.contentDecoration,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: SingleChildScrollView(
          padding: DashboardStyles.getContentPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMenuGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = DashboardStyles.getGridCrossAxisCount(context);
        final gridSpacing = DashboardStyles.getGridSpacing(context);
        final iconSize = DashboardStyles.getCardIconSize(context);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: gridSpacing,
            mainAxisSpacing: gridSpacing,
            childAspectRatio: 1,
          ),
          itemCount: menuOptions.length,
          itemBuilder: (context, index) {
            return _buildMenuCard(
              context,
              menuOptions[index],
              iconSize,
            );
          },
        );
      },
    );
  }

  Widget _buildMenuCard(
      BuildContext context, MenuOption option, double iconSize) {
    return Container(
      decoration: DashboardStyles.menuCardDecoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: option.onTap,
          borderRadius: BorderRadius.circular(AppStyles.radiusLarge),
          child: Padding(
            padding: EdgeInsets.all(AppStyles.getResponsiveSpacing(context)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(AppStyles.spacing12),
                  decoration: DashboardStyles.iconBoxDecoration,
                  child: Image.asset(
                    option.imagePath,
                    height: iconSize,
                    width: iconSize,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: AppStyles.spacing8),
                Text(
                  option.title,
                  style: DashboardStyles.getResponsiveMenuTitleStyle(context),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MenuOption {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  MenuOption({
    required this.title,
    required this.imagePath,
    required this.onTap,
  });
}
