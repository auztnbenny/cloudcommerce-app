import 'package:flutter/material.dart';
import '../dashboard/dashboard_page.dart';
import '../../styles/app_styles.dart';
import 'login_styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? selectedYear;
  String? selectedVehicle;
  bool isPasswordVisible = false;

  final List<String> years = List.generate(
    DateTime.now().year - 1999,
    (index) => (2000 + index).toString(),
  );

  final List<String> vehicleNumbers = [
    'Vehicle 1',
    'Vehicle 2',
    'Vehicle 3',
    'Vehicle 4',
    'Vehicle 5',
  ];

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isSmallScreen = size.width < AppStyles.mobileBreakpoint;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppStyles.getScreenPadding(context),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: AppStyles.spacing40),
                  Text(
                    'Sign In',
                    style: AppStyles.h1,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppStyles.spacing8),
                  Text(
                    'Hi! Welcome to Cloud Commerce!',
                    style: AppStyles.body2,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppStyles.spacing32),
                  _buildFormFields(isSmallScreen),
                  SizedBox(height: AppStyles.spacing24),
                  _buildSignInButton(),
                  SizedBox(height: AppStyles.spacing24),
                  _buildSocialSignIn(),
                  SizedBox(height: AppStyles.spacing24),
                  _buildSignUpLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormFields(bool isSmallScreen) {
    return Column(
      children: [
        _buildTextField(
          controller: _usernameController,
          hintText: 'Username',
          prefixIcon: Icons.person_outline,
        ),
        SizedBox(height: AppStyles.spacing16),
        _buildTextField(
          controller: _passwordController,
          hintText: 'Password',
          prefixIcon: Icons.lock_outline,
          isPassword: true,
        ),
        SizedBox(height: AppStyles.spacing16),
        if (isSmallScreen) ...[
          _buildDropdown(
            value: selectedYear,
            items: years,
            hint: 'Select Year',
            onChanged: (value) => setState(() => selectedYear = value),
          ),
          SizedBox(height: AppStyles.spacing16),
          _buildDropdown(
            value: selectedVehicle,
            items: vehicleNumbers,
            hint: 'Select Vehicle',
            onChanged: (value) => setState(() => selectedVehicle = value),
          ),
        ] else
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  value: selectedYear,
                  items: years,
                  hint: 'Select Year',
                  onChanged: (value) => setState(() => selectedYear = value),
                ),
              ),
              SizedBox(width: AppStyles.spacing16),
              Expanded(
                child: _buildDropdown(
                  value: selectedVehicle,
                  items: vehicleNumbers,
                  hint: 'Select Vehicle',
                  onChanged: (value) => setState(() => selectedVehicle = value),
                ),
              ),
            ],
          ),
        SizedBox(height: AppStyles.spacing16),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: Text(
              'Forgot Password?',
              style: AppStyles.body2.copyWith(
                color: AppStyles.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !isPasswordVisible,
      style: AppStyles.body1,
      decoration: LoginStyles.getTextFieldDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: AppStyles.textSecondaryColor,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              )
            : null,
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required void Function(String?)? onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((String item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item, style: AppStyles.body1),
        );
      }).toList(),
      onChanged: onChanged,
      style: AppStyles.body1,
      decoration: LoginStyles.getDropdownDecoration(hint),
      icon: Icon(Icons.arrow_drop_down, color: AppStyles.textSecondaryColor),
      dropdownColor: AppStyles.cardColor,
      isExpanded: true,
    );
  }

  Widget _buildSignInButton() {
    return ElevatedButton(
      onPressed: () {
        // You might want to add validation here
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
      },
      style: LoginStyles.getButtonStyle(context),
      child: const Text('Sign In'),
    );
  }

  Widget _buildSocialSignIn() {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppStyles.spacing16),
              child: Text('Or sign in with', style: AppStyles.caption),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        SizedBox(height: AppStyles.spacing24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SocialButton(
              onPressed: () {},
              icon: 'assets/icons/google.png',
            ),
            SizedBox(width: AppStyles.spacing16),
            _SocialButton(
              onPressed: () {},
              icon: 'assets/icons/apple-logo.png',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Don\'t have an account?', style: AppStyles.body2),
        TextButton(
          onPressed: () {},
          child: Text(
            'Sign Up',
            style: AppStyles.body2.copyWith(
              color: AppStyles.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String icon;

  const _SocialButton({
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
      child: Container(
        padding: EdgeInsets.all(AppStyles.spacing16),
        decoration: LoginStyles.socialButtonDecoration,
        child: Image.asset(
          icon,
          height: 24,
          width: 24,
        ),
      ),
    );
  }
}
