import 'package:akubakul/pages/sign_up_page.dart';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/auth_footer.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isPasswordVisible = false;
  bool isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // FocusNode untuk animasi input
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    emailFocus.addListener(_onFocusChange);
    passwordFocus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    emailFocus.removeListener(_onFocusChange);
    passwordFocus.removeListener(_onFocusChange);
    emailFocus.dispose();
    passwordFocus.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: defaultMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_buildHeader(), _buildLoginForm(), _buildFooter()],
            ),
          ),
        ),
      ),
    );
  }

  // HEADER SECTION
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        // Logo
        Align(
          alignment: Alignment.topLeft,
          child: Image.asset(
            'assets/image_splash.png',
            width: 154,
            height: 52,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 20),
        // Login title
        Text(
          'Login',
          style: primaryTextStyle.copyWith(fontSize: 24, fontWeight: semibold),
        ),
        const SizedBox(height: 2),
        // Sign up text
        Row(
          children: [
            Text(
              'Don\'t have an account? ',
              style: secondaryTextStyle.copyWith(fontSize: 14),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/sign-up');
              },
              child: Text(
                'Signup',
                style: titleTextStyle.copyWith(fontSize: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // FORM SECTION
  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email Field
        CustomInputField(
          label: 'Email',
          hintText: 'Enter your email',
          controller: emailController,
          focusNode: emailFocus,
        ),
        const SizedBox(height: 20),

        // Password Field
        CustomInputField(
          label: 'Password',
          hintText: 'Enter your password',
          controller: passwordController,
          focusNode: passwordFocus,
          obscureText: !isPasswordVisible,
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                isPasswordVisible = !isPasswordVisible;
              });
            },
            child: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Grey150,
            ),
          ),
        ),

        // Forgot password
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: Text(
              'Forgot password?',
              style: titleTextStyle.copyWith(fontSize: 12),
            ),
          ),
        ),
        const SizedBox(height: 30),

        // Login button
        isLoading
            ? Center(child: CircularProgressIndicator())
            : CustomButton(
              text: 'Login',
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                final authProvider = Provider.of<AuthProvider>(
                  context,
                  listen: false,
                );
                try {
                  bool success = await authProvider.login(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  setState(() {
                    isLoading = false;
                  });
                  if (success) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/home',
                      (route) => false,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Login gagal, cek email/password!'),
                      ),
                    );
                  }
                } catch (e) {
                  setState(() {
                    isLoading = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Terjadi kesalahan: $e')),
                  );
                }
              },
            ),
      ],
    );
  }

  // FOOTER SECTION
  Widget _buildFooter() {
    return AuthFooter(prefix: 'By login, you agree to');
  }
}
