
import 'package:flutter/material.dart';
import 'package:nexdoor/core/responsive/responsive.dart';
import 'package:nexdoor/features/auth/models/user.dart';
import 'package:nexdoor/features/auth/repositories/auth_repository.dart';
import 'package:nexdoor/features/user_profile/repositories/user_repository.dart';
import 'package:nexdoor/widgets/c_button_widget.dart';
import 'package:nexdoor/widgets/c_container.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (Responsive.isMobile(context)) {
      return const  MobileProfileScreen();
    } else {
      return const DesktopProfileScreen();
    }
  }
}

class DesktopProfileScreen extends StatelessWidget {
  const DesktopProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
      backgroundColor: Colors.transparent,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (Route<dynamic> route) => false,
              );
            },
            icon: const Icon(Icons.arrow_back)),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: const Padding(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CurrentUserProfileSection(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
    );
  }
}

class MobileProfileScreen extends StatelessWidget {
  const MobileProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.w500, // adjusting font weight
          ),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (Route<dynamic> route) => false,
              );
            },
            icon: const Icon(Icons.arrow_back)),
        centerTitle: false,
        elevation: 0.0,
      ),
      body: const Padding(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CurrentUserProfileSection(
                  isMobile: true,
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
    );
  }
}

class CurrentUserProfileSection extends StatefulWidget {
  const CurrentUserProfileSection({super.key, this.isMobile = false});
  final bool isMobile;
  @override
  State<CurrentUserProfileSection> createState() =>
      _CurrentUserProfileSectionState();
}

class _CurrentUserProfileSectionState extends State<CurrentUserProfileSection> {
  fetchuserInfo() async {
    try {
      UserDataService us = UserDataService();
      UserModel currentUserInfo = await us.fetchCurrentUserInfo();
      return currentUserInfo;
    } catch (e, s) {
      errorNotifier("fetchuserInfo()", e, s);
    }
  }

  void logOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Log out',
            style: TextStyle(fontSize: 20),
          ),
          content: const Text(
            "Are you sure you want to log out?",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'No, get back',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
            const VerticalDivider(
              width: 10,
              thickness: 5,
              indent: 0,
              endIndent: 0,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                AuthService auth = AuthService();
                auth.fsignOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text(
                'Log out',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            )
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        );
      },
    );
  }

  List<Widget> responsive(
      bool isMobile, UserModel currentUserInfo, BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;
    return [
      CustomContainer(
        height: 100,
        width: 100,
        shape: BoxShape.circle,
        enableAnimation: false,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.network(currentUserInfo.imageUrl ??
              "https://png.pngtree.com/png-vector/20240819/ourmid/pngtree-3d-person-icon-human-and-profile-illustration-logo-png-image_13542028.png"),
        ),
      ),
      (isMobile ? const SizedBox(height: 5) : const SizedBox(width: 30)),

      Column(
        crossAxisAlignment:
            isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            textAlign: isMobile ? TextAlign.center : null,
            currentUserInfo.name ?? currentUserInfo.email ?? "",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 30,
                color: color.inversePrimary.withValues(alpha:0.6)),
          ),
          Visibility(
            visible: currentUserInfo.name != null,
            child: Text(currentUserInfo.email ?? "",
                textAlign: isMobile ? TextAlign.center : null,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: color.inversePrimary.withValues(alpha:0.6),
                    fontSize: 15)),
          ),
          Visibility(
            visible: currentUserInfo.bio != null && currentUserInfo.bio != "",
            child: Text(currentUserInfo.bio ?? "",
                textAlign: isMobile ? TextAlign.center : null,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: color.inversePrimary.withValues(alpha:0.6))),
          ),
          Visibility(
            visible: (currentUserInfo.programme != null &&
                currentUserInfo.programme != ""),
            child: Text(
                textAlign: isMobile ? TextAlign.center : null,
                currentUserInfo.programme ?? "",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: color.inversePrimary.withValues(alpha:0.6))),
          ),
          Visibility(
            visible: (currentUserInfo.passingYear != null &&
                currentUserInfo.passingYear != ""),
            child: Text(
                textAlign: isMobile ? TextAlign.center : null,
                currentUserInfo.passingYear ?? "",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: color.inversePrimary.withValues(alpha:0.6))),
          ),
        ],
      ),
      (isMobile ? const SizedBox(height: 5) : const SizedBox(width: 30)),
// Get verified Button
      // Visibility(
      //   visible: !currentUserInfo.isVerified,
      //   child: CustomButton(
      //       padding: EdgeInsets.all(3),
      //       height: 30,
      //       width: 130,
      //       transparentbackgroundColor: true,
      //       title: "Get verified",
      //       onTap: () {
      //         AuthService auth = AuthService();
      //         auth.verification(context);
      //         int counter = 1;
      //         Timer.periodic(const Duration(seconds: 2), (timer) async {
      //           counter++;
      //           bool isverified = auth.checkVerification;
      //           // Goes around and around for 20 seconds
      //           if (isverified || counter == 10) {
      //             timer.cancel();
      //             setState(() {});
      //           }
      //         });
      //       }),
      // ),
      (isMobile ? const SizedBox(height: 5) : const SizedBox(width: 30)),
// Update Profile Button
      CustomButton(
        padding: const EdgeInsets.all(3),
        height: 30,
        width: 140,
        transparentbackgroundColor: true,
        title: "Update profile",
        onTap: () {
          Navigator.pushNamed(context, '/addUser');
        },
      ),
      (isMobile ? const SizedBox(height: 5) : const SizedBox(width: 30)),
      CustomButton(
        fontSize: 14,
        padding: const EdgeInsets.all(3),
        height: 30,
        width: 140,
        transparentbackgroundColor: true,
        title: "Log out",
        onTap: () {
          logOut(context);
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchuserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator.adaptive();
        } else if (snapshot.hasData) {
          UserModel currentUserInfo = snapshot.data as UserModel;
          return widget.isMobile
              ? Column(children: responsive(true, currentUserInfo, context))
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: responsive(false, currentUserInfo, context));
        } else {
          return Center(
              child: Column(
            children: [
              const Text("An error occured while trying to fetch data"),
              const SizedBox(height: 10),
              SizedBox(
                width: 100,
                child: CustomButton(
                  padding: const EdgeInsets.all(3),
                  height: 30,
                  width: 110,
                  transparentbackgroundColor: true,
                  title: "Log out",
                  onTap: () {
                    logOut(context);
                  },
                ),
              ),
            ],
          ));
        }
      },
    );
  }
}

