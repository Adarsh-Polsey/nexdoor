import 'package:flutter/material.dart';
import 'package:nexdoor/common/core/theme/color_pallete.dart';

class SettingsScreen extends StatelessWidget {
  final String userName = "John Doe"; // Replace with actual user data
  final String userEmail = "johndoe@example.com"; // Replace with actual user data

  const SettingsScreen({super.key}); // Replace with actual profile image URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Section
            _buildProfileSection(),
            SizedBox(height: 20),
            // Grid of Settings Options
            Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:200.0),
                child: GridView.count(
                  crossAxisCount: 4, // 3 columns
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    _buildSettingsBox(
                    icon: Icons.business_outlined,
                    label: 'Create Business Account',
                    onTap: () {
                      // Navigate to Create Business Account Screen
                      print('Create Business Account Tapped');
                    },
                  ),
                    _buildSettingsBox(
                      icon: Icons.edit_outlined,
                      label: 'Edit Profile',
                      onTap: () {
                        // Navigate to Edit Profile Screen
                        print('Edit Profile Tapped');
                      },
                    ),
                    
                    _buildSettingsBox(
                      icon: Icons.lock_reset_outlined,
                      label: 'Reset Password',
                      onTap: () {
                        // Navigate to Reset Password Screen
                        print('Reset Password Tapped');
                      },
                    ),
                      _buildSettingsBox(
                      icon: Icons.logout_outlined,
                      label: 'Log Out',
                      onTap: () {
                        // Handle Log Out
                        print('Log Out Tapped');
                      },
                    ),
                    _buildSettingsBox(
                      icon: Icons.description_outlined,
                      label: 'T&C',
                      onTap: () {
                        // Navigate to Terms & Conditions Screen
                        print('T&C Tapped');
                      },
                    ),
                     _buildSettingsBox(
                      icon: Icons.info_outline,
                      label: 'About Nexdoor',
                      onTap: () {
                        // Navigate to About Nexdoor Screen
                        print('About Nexdoor Tapped');
                      },
                    ),
                    _buildSettingsBox(
                      icon: Icons.delete_outline,
                      label: 'Delete Account',
                      onTap: () {
                        // Handle Delete Account
                        print('Delete Account Tapped');
                      },
                    ),
                     _buildSettingsBox(
                      icon: Icons.home_outlined,
                      label: 'Home',
                      onTap: () {
                        
                        print('Home Tapped');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Profile Section Widget
  Widget _buildProfileSection() {
    return Row(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          userName,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          userEmail,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  // Settings Box Widget
  Widget _buildSettingsBox({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(height: 100,width: 100,
        decoration: BoxDecoration(
          color: ColorPalette.secondaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(child: Icon(icon, size: 50)),
            SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}