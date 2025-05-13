import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/auth_footer.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isPasswordVisible = false;
  bool isLoading = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // FocusNode untuk animasi input
  final FocusNode nameFocus = FocusNode();
  final FocusNode usernameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    nameFocus.addListener(_onFocusChange);
    usernameFocus.addListener(_onFocusChange);
    emailFocus.addListener(_onFocusChange);
    passwordFocus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    nameFocus.removeListener(_onFocusChange);
    usernameFocus.removeListener(_onFocusChange);
    emailFocus.removeListener(_onFocusChange);
    passwordFocus.removeListener(_onFocusChange);

    nameFocus.dispose();
    usernameFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();

    nameController.dispose();
    usernameController.dispose();
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
              children: [_buildHeader(), _buildSignUpForm(), _buildFooter()],
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
        // Signup title
        Text(
          'Signup',
          style: primaryTextStyle.copyWith(fontSize: 24, fontWeight: semibold),
        ),
        const SizedBox(height: 2),
        // Login text
        Row(
          children: [
            Text(
              'Already have an account? ',
              style: secondaryTextStyle.copyWith(fontSize: 14),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                'Login',
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
  Widget _buildSignUpForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full Name Field
        CustomInputField(
          label: 'Full Name',
          hintText: 'Enter your full name',
          controller: nameController,
          focusNode: nameFocus,
        ),
        const SizedBox(height: 20),

        // Username Field
        CustomInputField(
          label: 'Username',
          hintText: 'Enter your username',
          controller: usernameController,
          focusNode: usernameFocus,
        ),
        const SizedBox(height: 20),

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
        const SizedBox(height: 30),

        // Create Account button
        isLoading
            ? Center(child: CircularProgressIndicator())
            : CustomButton(
              text: 'Create Account',
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                final authProvider = Provider.of<AuthProvider>(
                  context,
                  listen: false,
                );
                try {
                  bool success = await authProvider.register(
                    name: nameController.text,
                    username: usernameController.text,
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  setState(() {
                    isLoading = false;
                  });
                  if (success) {
                    Navigator.pushReplacementNamed(context, '/home');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Register gagal, cek data Anda!')),
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
    return AuthFooter(prefix: 'By signing up, you agree to');
  }
}
