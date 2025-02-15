import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nexdoor/common/core/theme/color_pallete.dart';
import 'package:nexdoor/features/settings_profile/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<UserViewModel>(context, listen: false).fetchUserData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 200.0),
        child: Consumer<UserViewModel>(
          builder: (context, userViewModel, child) {
            if (userViewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final user = userViewModel.user;
            final userName = user?.fullName ?? "John Doe";
            final userEmail = user?.email ?? "johndoe@example.com";
            final phoneNo = user?.phoneNumber ?? "12398712873";
            final address =
                user?.location ?? "efuhweuifhuwhef  rgferg  rg er g ergreg";
            final isBusiness = user?.isBusiness ?? false;
            log(isBusiness.toString());
            return Column(
              children: [
                const SizedBox(height: 10),
                _buildProfileSection(userName, userEmail, phoneNo, address),
                const SizedBox(height: 10),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      if ((isBusiness)) ...[
                        _buildSettingsBox(
                          icon: Icons.manage_accounts_outlined,
                          label: 'Manage Business',
                          onTap: () {
                            Navigator.pushNamed(context, '/manage_business');
                          },
                        ),
                        _buildSettingsBox(
                          icon: Icons.add_business_outlined,
                          label: 'Add Services',
                          onTap: () {
                            print('Add services Tapped');
                          },
                        ),
                      ],
                      _buildSettingsBox(
                        icon: Icons.edit_outlined,
                        label: 'Edit Profile',
                        onTap: () {
                          print('Edit Profile Tapped');
                        },
                      ),
                      _buildSettingsBox(
                        icon: Icons.lock_reset_outlined,
                        label: 'Reset Password',
                        onTap: () {
                          print('Reset Password Tapped');
                        },
                      ),
                      _buildSettingsBox(
                        icon: Icons.logout_outlined,
                        label: 'Log Out',
                        onTap: () {
                          userViewModel.clearUserData();
                        },
                      ),
                      _buildSettingsBox(
                        icon: Icons.description_outlined,
                        label: 'T&C',
                        onTap: () {
                          print('T&C Tapped');
                        },
                      ),
                      _buildSettingsBox(
                        icon: Icons.info_outline,
                        label: 'About Nexdoor',
                        onTap: () {
                          print('About Nexdoor Tapped');
                        },
                      ),
                       _buildSettingsBox(
                          icon: Icons.delete_outline,
                          label: 'Delete Account',
                          onTap: () {
                            print('Delete Account Tapped');
                          },
                        ),
                      if (!isBusiness) ...[
                        _buildSettingsBox(
                          icon: Icons.home_outlined,
                          label: 'Home',
                          onTap: () {
                            print('Home Tapped');
                          },
                        ),
                        _buildSettingsBox(
                        icon: Icons.business_outlined,
                        label: 'Create Business Account',
                        onTap: () {
                          Navigator.pushNamed(context, '/create_business');
                        },
                      ),
                      ]
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileSection(
      String userName, String userEmail, String phoneNo, String address) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorPalette.secondaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "Email: $userEmail",
            style: TextStyle(
                fontSize: 14, color: ColorPalette.accentColor.withAlpha(150)),
          ),
          Text(
            "Contact: $phoneNo",
            style: TextStyle(
                fontSize: 14, color: ColorPalette.accentColor.withAlpha(150)),
          ),
          Text(
            "Location: $address",
            style: TextStyle(
                fontSize: 14, color: ColorPalette.accentColor.withAlpha(150)),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsBox({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: ColorPalette.secondaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(child: Icon(icon, size: 50)),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
