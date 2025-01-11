import 'package:cloudcommerce/pages/dashboard/settings_page.dart';
import 'package:cloudcommerce/pages/todaysorders/orders_page.dart';
import 'package:flutter/material.dart';
import '../../styles/app_styles.dart';
import '../../styles/bottom_nav_styles.dart';
import '../../widgets/custom_bottom_nav.dart';
import 'dashboard_styles.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  late List<MenuOption> menuOptions;

  @override
  void initState() {
    super.initState();
    menuOptions = [
      MenuOption(
        title: 'Stock item list',
        imagePath: 'assets/images/today.png',
        onTap: () {},
      ),
      MenuOption(
        title: 'Party List',
        imagePath: 'assets/images/today.png',
        onTap: () {},
      ),
      MenuOption(
        title: 'Users Order',
        imagePath: 'assets/images/today.png',
        onTap: () {},
      ),
      MenuOption(
        title: 'Order Monthwise list',
        imagePath: 'assets/images/today.png',
        onTap: () {},
      ),
      MenuOption(
        title: 'Current Month orders',
        imagePath: 'assets/images/today.png',
        onTap: () {},
      ),
      MenuOption(
        title: 'Todays Orders',
        imagePath: 'assets/images/today.png',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OrdersPage()),
          );
        },
      ),
      MenuOption(
        title: 'Currency Check',
        imagePath: 'assets/images/today.png',
        onTap: () {},
      ),
      MenuOption(
        title: 'Vehicle Route',
        imagePath: 'assets/images/today.png',
        onTap: () {},
      ),
      MenuOption(
        title: 'Todays Payment',
        imagePath: 'assets/images/today.png',
        onTap: () {},
      ),
      MenuOption(
        title: 'Todays Expense',
        imagePath: 'assets/images/today.png',
        onTap: () {},
      ),
      MenuOption(
        title: 'Orderwise Itemlist',
        imagePath: 'assets/images/today.png',
        onTap: () {},
      ),
      MenuOption(
        title: 'Employee Master List View',
        imagePath: 'assets/images/today.png',
        onTap: () {},
      ),
      MenuOption(
        title: 'Approval',
        imagePath: 'assets/images/today.png',
        onTap: () {},
      ),
      MenuOption(
        title: 'Employee Details',
        imagePath: 'assets/images/today.png',
        onTap: () {},
      ),
      MenuOption(
        title: 'Location List',
        imagePath: 'assets/images/today.png',
        onTap: () {},
      ),
      MenuOption(
        title: 'Accounts',
        imagePath: 'assets/images/today.png',
        onTap: () {},
      ),
      MenuOption(
        title: 'Daily Attendence',
        imagePath: 'assets/images/today.png',
        onTap: () {},
      ),
      MenuOption(
        title: 'Organization Master',
        imagePath: 'assets/images/today.png',
        onTap: () {},
      ),
    ];
  }

  // In your DashboardPage build method:
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.primaryColor,
      body: SafeArea(
        bottom: false, // Don't pad the bottom as BottomNav handles it
        child: _buildBody(),
      ),
      floatingActionButton: SizedBox(
        width: BottomNavStyles.getFabSize(context),
        height: BottomNavStyles.getFabSize(context),
        child: FloatingActionButton(
          onPressed: () {
            // Add your action here
          },
          child: Icon(
            Icons.add,
            size: BottomNavStyles.getFabIconSize(context),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 3) {
            // Profile icon index
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
      ),
    );
  }

  // Update your _buildBody method:
  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _buildContent(context),
            ),
          ],
        );
      case 1:
        return Center(
          child: Text(
            'Search',
            style: AppStyles.h1.copyWith(color: Colors.white),
          ),
        );
      case 2:
        return Center(
          child: Text(
            'Notifications',
            style: AppStyles.h1.copyWith(color: Colors.white),
          ),
        );
      case 3:
        return Center(
          child: Text(
            'Profile',
            style: AppStyles.h1.copyWith(color: Colors.white),
          ),
        );
      default:
        return Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _buildContent(context),
            ),
          ],
        );
    }
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
