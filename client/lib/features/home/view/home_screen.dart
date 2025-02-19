import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:nexdoor/common/core/theme/color_pallete.dart';
import 'package:nexdoor/features/ai_chat/view/ai_chat_screen.dart';
import 'package:nexdoor/features/business/view/view_businesses_screen.dart';
import 'package:nexdoor/features/settings_profile/view/settings_screen.dart';
import 'package:nexdoor/widgets/c_textfield_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> activePage = [
    ViewBusinessScreen(),
    ChatScreen(),
    SettingsScreen(),
  ];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
// AppBar
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            // LocalEase Logo
            child: Text(
              ' LocalEase',
              style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
          ),
          leadingWidth: 200,
          // Search Bar
          // title: Container(
          //   width: 500,
          //   height: 40,
          //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          //   child: CustomTextField(
          //     controller: TextEditingController(),
          //     hinttext: "Search for anything...",
          //     icon: Icon(
          //       Icons.search,
          //       color: Colors.black,
          //     ),
          //   ),
          // ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 2,
          // Profile and notifications
          actions: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: ColorPalette.selectionColor),
                  shape: BoxShape.circle),
              child: IconButton(
                  color: ColorPalette.primaryButtonHover,
                  icon: Icon(
                    Icons.notifications_outlined,
                    color: ColorPalette.primaryButtonSplash,
                  ),
                  onPressed: () {
                    // Navigator.pushNamed(context, '/profile');
                  }),
            ),
            SizedBox(width: 10)
          ],
        ),
// Body of posts
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(child: activePage[selectedIndex]),
          ],
        ),
// Bottom navigation bar
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
            width: 500,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border.all(width: 2, color: ColorPalette.primaryButtonSplash),
              borderRadius: BorderRadius.circular(50),
            ),
            child: GNav(
                haptic: true, // haptic feedback
                tabBorderRadius: 15,
                tabActiveBorder: Border.all(
                    color: Colors.black, width: 1), // tab button border
                tabBorder: Border.all(
                    color: Colors.white, width: 1), // tab button border
                // tab button shadow
                gap: 8,
                color: Colors.grey[800], // unselected icon color
                activeColor:
                    ColorPalette.secondaryText, // selected icon and text color
                iconSize: 24, // tab button icon size
                tabBackgroundColor: ColorPalette.primaryButtonSplash,
                padding: EdgeInsets.symmetric(
                    horizontal: 20, vertical: 5), // navigation bar padding
                tabs: [
                  GButton(
                      icon: Icons.home,
                      text: 'Home',
                      onPressed: () {
                        setState(() {
                          selectedIndex = 0;
                        });
                      }),
                  GButton(
                      icon: Icons.shopping_bag_outlined,
                      text: 'Selling',
                      onPressed: () {
                        setState(() {
                          selectedIndex = 1;
                        });
                      }),
                  GButton(
                      icon: Icons.chat_bubble_outline,
                      text: 'Assistant',
                      onPressed: () {
                        setState(() {
                          selectedIndex = 2;
                        });
                      }),
                  GButton(
                    icon: Icons.group_outlined,
                    text: 'Groups',
                    onPressed: () {
                      setState(() {
                        selectedIndex = 3;
                      });
                    },
                  ),
                  GButton(
                      icon: Icons.settings_outlined,
                      text: 'Setting',
                      onPressed: () {
                        setState(() {
                          selectedIndex = 4;
                        });
                      }),
                ])));
  }
}
