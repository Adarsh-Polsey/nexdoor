import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexdoor/core/theme/color_pallete.dart';
import 'package:nexdoor/features/home/view/discussion_screen.dart';
import 'package:nexdoor/features/home/view/help_screen.dart';
import 'package:nexdoor/features/home/view/notification_screen.dart';
import 'package:nexdoor/features/home/view/post_screen.dart';
import 'package:nexdoor/features/home/view/sell_screen.dart';
import 'package:nexdoor/features/home/view/settings_screen.dart';
import 'package:nexdoor/widgets/c_textfield_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> activePage = [
    PostScreen(),
    SellScreen(),
    NotificationScreen(),
    GroupScreen(),
    SettingsScreen(),
    HelpCenterScreen()
  ];
  int selectedIndex = 0;
  Widget _drawerItem(int index, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: ColorPalette.secondaryColor),
      title: Text(title,
          style: TextStyle(
            fontSize: 16,
          )),
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
        log(selectedIndex.toString());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            ' LocalEase',
            style: GoogleFonts.poppins(
                fontSize: 26, fontWeight: FontWeight.bold, color: Colors.green),
          ),
        ),
        leadingWidth: 200,
        title: Container(
          width: 500,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
          child: CustomTextField(
            controller: TextEditingController(),
            hinttext: "Search for anything...",
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                      ColorPalette.primaryButtonSplash)),
              color: ColorPalette.primaryButtonHover,
              icon: Icon(
                Icons.person_2_outlined,
                color: ColorPalette.backgroundColor,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              }),
          SizedBox(width: 10)
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Drawer(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      _drawerItem(0, Icons.home_outlined, "Home"),
                      _drawerItem(1, Icons.shopping_bag_outlined, "For Sale & Free"),
                      _drawerItem(2, Icons.notifications_active_outlined,"Notifications"),
                      _drawerItem(3, Icons.group_outlined, "Groups"),
                      Expanded(child: SizedBox()),
                      _drawerItem(4, Icons.settings_outlined, "Settings"),
                      _drawerItem(5, Icons.help_center_outlined, "Help Center"),
                    ],
                  ),
                ),
              )),
              VerticalDivider(),
          Flexible(flex: 8, child: activePage[selectedIndex]),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.green,
        child: Icon(Icons.post_add, color: Colors.white),
      ),
    );
  }
}
