import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';
import '../../widgets/profile/profile_menu_item.dart';
import '../../providers/auth_provider.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    return Scaffold(
      backgroundColor: Cyan,
      body:
          user == null
              ? _buildShimmerProfile()
              : Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.only(
                      top: 32,
                      left: 20,
                      right: 20,
                      bottom: 24,
                    ),
                    color: Cyan,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Foto profil
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.grey[300],
                          backgroundImage:
                              user.profilePhotoUrl.isNotEmpty
                                  ? NetworkImage(user.profilePhotoUrl)
                                  : null,
                          child:
                              user.profilePhotoUrl.isEmpty
                                  ? Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 32,
                                  )
                                  : null,
                        ),
                        const SizedBox(width: 16),
                        // Nama & email
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: primaryTextStyle.copyWith(
                                  fontSize: 18,
                                  fontWeight: bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.email,
                                style: primaryTextStyle.copyWith(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        // Tombol refresh/logout
                        IconButton(
                          icon: Icon(Icons.logout_rounded, color: White),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  // Card Section
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Black,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: ListView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 24,
                        ),
                        children: [
                          // Personal Information
                          Text(
                            'Personal Information',
                            style: primaryTextStyle.copyWith(
                              fontWeight: bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Black,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                ProfileMenuItem(
                                  icon: Icons.person_outline,
                                  label: 'Edit Profile',
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/edit-profile',
                                    );
                                  },
                                ),
                                Divider(color: Grey100, height: 1),
                                ProfileMenuItem(
                                  icon: Icons.local_shipping_outlined,
                                  label: 'Shipping Address',
                                  onTap: () {},
                                ),
                                Divider(color: Grey100, height: 1),
                                ProfileMenuItem(
                                  icon: Icons.credit_card,
                                  label: 'Payment Method',
                                  onTap: () {},
                                ),
                                Divider(color: Grey100, height: 1),
                                ProfileMenuItem(
                                  icon: Icons.history,
                                  label: 'Order History',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Support & Information
                          Text(
                            'Support & Information',
                            style: primaryTextStyle.copyWith(
                              fontWeight: bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Black,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                ProfileMenuItem(
                                  icon: Icons.privacy_tip_outlined,
                                  label: 'Privacy Policy',
                                  onTap: () {},
                                ),
                                Divider(color: Grey100, height: 1),
                                ProfileMenuItem(
                                  icon: Icons.article_outlined,
                                  label: 'Terms & Conditions',
                                  onTap: () {},
                                ),
                                Divider(color: Grey100, height: 1),
                                ProfileMenuItem(
                                  icon: Icons.help_outline,
                                  label: 'FAQs',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Account Management
                          Text(
                            'Account Management',
                            style: primaryTextStyle.copyWith(
                              fontWeight: bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Black,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ProfileMenuItem(
                              icon: Icons.lock_outline,
                              label: 'Change Password',
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/change-password',
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildShimmerProfile() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: 32,
              left: 20,
              right: 20,
              bottom: 24,
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                ),
                Container(
                  width: 32,
                  height: 32,
                  color: Colors.white,
                  margin: EdgeInsets.only(left: 8),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Black,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                itemCount: 6,
                itemBuilder:
                    (context, index) => Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      height: 32,
                      width: double.infinity,
                      color: Colors.white,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
