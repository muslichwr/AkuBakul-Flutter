import 'package:flutter/material.dart';
import '../../theme.dart';
import '../custom_input_field.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _oldPasswordFocus = FocusNode();
  final _newPasswordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  bool _isStepOld = true;
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _oldPasswordFocus.addListener(_onFocusChange);
    _newPasswordFocus.addListener(_onFocusChange);
    _confirmPasswordFocus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _oldPasswordFocus.removeListener(_onFocusChange);
    _newPasswordFocus.removeListener(_onFocusChange);
    _confirmPasswordFocus.removeListener(_onFocusChange);
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _oldPasswordFocus.dispose();
    _newPasswordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  void _nextStep() {
    if (_oldPasswordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Password lama wajib diisi!')));
      return;
    }
    setState(() {
      _isStepOld = false;
    });
  }

  void _saveNewPassword() {
    if (_newPasswordController.text.trim().isEmpty ||
        _confirmPasswordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Semua field wajib diisi!')));
      return;
    }
    if (_newPasswordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password baru minimal 6 karakter!')),
      );
      return;
    }
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Konfirmasi password tidak sama!')),
      );
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Password berhasil diganti!')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Black,
        appBar: AppBar(
          backgroundColor: Black,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: White),
            onPressed: () => Navigator.pop(context),
            tooltip: 'Kembali',
          ),
          centerTitle: true,
          title: Text(
            'Ganti Password',
            style: primaryTextStyle.copyWith(fontWeight: bold, fontSize: 18),
          ),
        ),
        body: Form(
          key: _formKey,
          child:
              _isStepOld
                  ? _buildOldPasswordStep(context)
                  : _buildNewPasswordStep(context),
        ),
      ),
    );
  }

  Widget _buildOldPasswordStep(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 24,
      ).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Masukkan password lama Anda',
            style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium),
          ),
          const SizedBox(height: 24),
          CustomInputField(
            label: 'Password Lama',
            hintText: 'Masukkan password lama',
            controller: _oldPasswordController,
            focusNode: _oldPasswordFocus,
            obscureText: !_isOldPasswordVisible,
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _isOldPasswordVisible = !_isOldPasswordVisible;
                });
              },
              child: Icon(
                _isOldPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Grey150,
              ),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Cyan,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _nextStep,
              child: Text(
                'Lanjut',
                style: primaryTextStyle.copyWith(
                  fontWeight: bold,
                  fontSize: 16,
                  color: Black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewPasswordStep(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 24,
      ).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Masukkan password baru Anda',
            style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium),
          ),
          const SizedBox(height: 24),
          CustomInputField(
            label: 'Password Baru',
            hintText: 'Masukkan password baru',
            controller: _newPasswordController,
            focusNode: _newPasswordFocus,
            obscureText: !_isNewPasswordVisible,
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _isNewPasswordVisible = !_isNewPasswordVisible;
                });
              },
              child: Icon(
                _isNewPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Grey150,
              ),
            ),
          ),
          const SizedBox(height: 20),
          CustomInputField(
            label: 'Konfirmasi Password Baru',
            hintText: 'Ulangi password baru',
            controller: _confirmPasswordController,
            focusNode: _confirmPasswordFocus,
            obscureText: !_isConfirmPasswordVisible,
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
              child: Icon(
                _isConfirmPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Grey150,
              ),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Cyan,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _saveNewPassword,
              child: Text(
                'Simpan',
                style: primaryTextStyle.copyWith(
                  fontWeight: bold,
                  fontSize: 16,
                  color: Black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
