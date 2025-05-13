import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';
import '../custom_input_field.dart';
import '../../providers/auth_provider.dart';
import 'package:shimmer/shimmer.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _usernameFocus = FocusNode();
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();

  double _avatarScale = 1.0;
  bool _isLoading = false;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final user = Provider.of<AuthProvider>(context, listen: false).user;
      if (user != null) {
        _usernameController.text = user.username;
        _nameController.text = user.name;
        _emailController.text = user.email;
        _phoneController.text =
            user.profilePhotoUrl; // fallback jika phone null
        if (user.profilePhotoUrl == null || user.profilePhotoUrl.isEmpty) {
          _phoneController.text = '';
        }
      }
      _isInit = true;
    }
  }

  @override
  void initState() {
    super.initState();
    _usernameFocus.addListener(_onFocusChange);
    _nameFocus.addListener(_onFocusChange);
    _emailFocus.addListener(_onFocusChange);
    _phoneFocus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _usernameFocus.removeListener(_onFocusChange);
    _nameFocus.removeListener(_onFocusChange);
    _emailFocus.removeListener(_onFocusChange);
    _phoneFocus.removeListener(_onFocusChange);
    _usernameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _usernameFocus.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  void _onAvatarTap() async {
    setState(() => _avatarScale = 0.92);
    HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 120));
    setState(() => _avatarScale = 1.0);
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text('Ganti Foto Profil', style: primaryTextStyle),
            content: Text(
              'Fitur ganti foto coming soon.',
              style: secondaryTextStyle,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Tutup',
                  style: primaryTextStyle.copyWith(color: Cyan),
                ),
              ),
            ],
          ),
    );
  }

  String? _validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) return 'Username wajib diisi';
    if (value.trim().length < 4) return 'Minimal 4 karakter';
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Nama wajib diisi';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email wajib diisi';
    if (!value.contains('@')) return 'Format email tidak valid';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'No. HP wajib diisi';
    if (value.trim().length < 8) return 'No. HP tidak valid';
    return null;
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user;
      if (user == null) return;
      bool success = await authProvider.updateProfile(
        userId: user.id,
        name: _nameController.text,
        username: _usernameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        token: user.token,
      );
      setState(() => _isLoading = false);
      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Profil berhasil disimpan!')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal update profil!')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    if (user == null) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 32, bottom: 24),
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 120,
              height: 16,
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 8),
            ),
            Container(
              width: 180,
              height: 16,
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 8),
            ),
          ],
        ),
      );
    }
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
            'Edit Profile',
            style: primaryTextStyle.copyWith(fontWeight: bold, fontSize: 18),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            children: [
              Center(
                child: GestureDetector(
                  onTap: _onAvatarTap,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    curve: Curves.easeInOut,
                    width: 88 * _avatarScale,
                    height: 88 * _avatarScale,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Cyan, width: 2),
                    ),
                    child: ClipOval(
                      child:
                          user.profilePhotoUrl.isNotEmpty
                              ? Image.network(
                                user.profilePhotoUrl,
                                fit: BoxFit.cover,
                                width: 88,
                                height: 88,
                              )
                              : Container(color: Colors.grey[300]),
                    ),
                  ),
                ),
              ),
              CustomInputField(
                label: 'Username',
                hintText: 'Masukkan username',
                controller: _usernameController,
                focusNode: _usernameFocus,
              ),
              const SizedBox(height: 16),
              CustomInputField(
                label: 'Nama Lengkap',
                hintText: 'Masukkan nama lengkap',
                controller: _nameController,
                focusNode: _nameFocus,
              ),
              const SizedBox(height: 16),
              CustomInputField(
                label: 'Email',
                hintText: 'Masukkan email',
                controller: _emailController,
                focusNode: _emailFocus,
              ),
              const SizedBox(height: 16),
              CustomInputField(
                label: 'No. HP',
                hintText: 'Masukkan nomor HP',
                controller: _phoneController,
                focusNode: _phoneFocus,
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
                  onPressed: _isLoading ? null : _saveProfile,
                  child:
                      _isLoading
                          ? CircularProgressIndicator(color: Black)
                          : Text(
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
        ),
      ),
    );
  }
}
