import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nexdoor/common/core/theme/color_pallete.dart';
import 'package:nexdoor/features/auth/repositories/auth_repository.dart';
import 'package:nexdoor/features/settings_profile/viewmodel/profile_viewmodel.dart';
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
        Provider.of<ProfileViewModel>(context, listen: false).fetchUserData());
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 200.0),
      child: Consumer<ProfileViewModel>(
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
          final maxedBusiness = user?.maxedBusiness ?? false;
          final maxedServices = user?.maxedServices ?? false;
          log(maxedBusiness.toString());
          log(maxedServices.toString());
          
          return Column(
            children: [
              const SizedBox(height: 10),
              _buildProfileSection(userName, userEmail, phoneNo, address),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    if (maxedBusiness) ...[
                      _buildSettingsListItem(
                        icon: Icons.manage_accounts_outlined,
                        label: 'Manage Business',
                        onTap: () {
                          Navigator.pushNamed(context, '/manage_business');
                        },
                      ),
                      _buildSettingsListItem(
                        icon: Icons.add_business_outlined,
                        label: 'Manage Service',
                        onTap: () {
                          Navigator.pushNamed(context, '/manage_services');
                        },
                      ),
                    ],
                    _buildSettingsListItem(
                      icon: Icons.lock_reset_outlined,
                      label: 'Reset Password',
                      onTap: () {
                        AuthRepository authRepository=AuthRepository();
                        authRepository.resetPassword(userEmail);
                      },
                    ),
                    
                    _buildSettingsListItem(
                      icon: Icons.description_outlined,
                      label: 'T&C',
                      onTap: () {
                        Navigator.pushNamed(context, '/t_and_c');
                      },
                    ),
                    _buildSettingsListItem(
                      icon: Icons.info_outline,
                      label: 'About Nexdoor',
                      onTap: () {
                        Navigator.pushNamed(context, '/about');
                      },
                    ),
                    if (!maxedBusiness) ...[
                      _buildSettingsListItem(
                        icon: Icons.business_outlined,
                        label: 'Create Business',
                        onTap: () {
                          Navigator.pushNamed(context, '/create_business');
                        },
                      ),
                    ],
                    _buildSettingsListItem(
                      icon: Icons.logout_outlined,
                      label: 'Log Out',
                      onTap: () {
                        userViewModel.clearUserData();
                        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                      },
                    ),
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

Widget _buildSettingsListItem({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return Card(
    elevation: 1,
    margin: const EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Icon(icon, size: 30, color: ColorPalette.accentColor),
      title: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      tileColor: ColorPalette.secondaryColor.withOpacity(0.05),
    ),
  );
}}