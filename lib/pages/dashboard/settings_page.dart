import 'package:cloudcommerce/pages/dashboard/settings_styles.dart';
import 'package:cloudcommerce/pages/login/loginpage.dart';
import 'package:flutter/material.dart';
import '../../styles/app_styles.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppStyles.primaryColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: SettingsStyles.deleteColor),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9FE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF9FE),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: AppStyles.h2.copyWith(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: SettingsStyles.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppStyles.spacing16),
            const Text('GENERAL', style: SettingsStyles.sectionHeaderStyle),
            const SizedBox(height: AppStyles.spacing16),
            _buildGeneralSection(context),
            const SizedBox(height: AppStyles.spacing32),
            const Text('FEEDBACK', style: SettingsStyles.sectionHeaderStyle),
            const SizedBox(height: AppStyles.spacing16),
            _buildFeedbackSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralSection(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(
          'Account',
          Icons.person_outline,
          onTap: () {},
        ),
        _buildMenuItem(
          'Notifications',
          Icons.notifications_none,
          onTap: () {},
        ),
        _buildMenuItem(
          'Coupons',
          Icons.confirmation_number_outlined,
          onTap: () {},
        ),
        _buildMenuItem(
          'Logout',
          Icons.logout,
          onTap: () => _handleLogout(context),
        ),
        _buildMenuItem(
          'Delete account',
          Icons.delete_outline,
          onTap: () {},
          isDelete: true,
        ),
      ],
    );
  }

  Widget _buildFeedbackSection() {
    return Column(
      children: [
        _buildMenuItem(
          'Report a bug',
          Icons.warning_amber_rounded,
          onTap: () {},
        ),
        _buildMenuItem(
          'Send feedback',
          Icons.send,
          onTap: () {},
          showDivider: false,
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    String title,
    IconData icon, {
    required VoidCallback onTap,
    bool showDivider = true,
    bool isDelete = false,
  }) {
    return Container(
      decoration: showDivider ? SettingsStyles.itemDecoration : null,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: SettingsStyles.itemPadding,
          child: Row(
            children: [
              Icon(
                icon,
                size: 24,
                color: isDelete
                    ? SettingsStyles.deleteColor
                    : AppStyles.textPrimaryColor,
              ),
              const SizedBox(width: AppStyles.spacing16),
              Expanded(
                child: Text(
                  title,
                  style: SettingsStyles.menuItemStyle.copyWith(
                    color: isDelete
                        ? SettingsStyles.deleteColor
                        : AppStyles.textPrimaryColor,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isDelete
                    ? SettingsStyles.deleteColor
                    : AppStyles.secondaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
