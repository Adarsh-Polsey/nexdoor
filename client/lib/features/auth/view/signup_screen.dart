import 'package:flutter/material.dart';
import 'package:nexdoor/features/settings_profile/models/user_model.dart';
import 'package:nexdoor/features/auth/repositories/auth_repository.dart';
import 'package:nexdoor/widgets/c_button_widget.dart';
import 'package:nexdoor/widgets/c_textfield_widget.dart';
import 'package:nexdoor/common/core/responsive/responsive.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (Responsive.isMobile(context)) {
      return Scaffold(body: MobileSignUpScreen());
    } else {
      return Scaffold(body: DeskTopSignUpScreen());
    }
  }
}

// Mobile screen
class MobileSignUpScreen extends StatelessWidget {
  const MobileSignUpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: SignUpWidget(isDesktop: false)),
    );
  }
}

// Desktop screen
class DeskTopSignUpScreen extends StatelessWidget {
  const DeskTopSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Flexible(flex: 3, child: SizedBox(width: double.infinity)),
        Flexible(
          flex: 3,
          child: SignUpWidget(
            isDesktop: true,
          ),
        ),
        Flexible(flex: 3, child: SizedBox(width: double.infinity)),
      ],
    );
  }
}

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({super.key, required this.isDesktop});
  final bool isDesktop;
  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isSigningUp = false;
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneNumberController.dispose();
    locationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Sign Up",
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(height: 40),
          // Email
          CustomTextField(
            labeltext: "Email",
            controller: emailController,
            enableBorder: false,
            hinttext: "xyz@gmail.com",
            margin: EdgeInsets.symmetric(vertical: 20),
          ),
           // Full name
          CustomTextField(
            labeltext: "Full name",
            controller: nameController,
            enableBorder: false,
            hinttext: "John Doe",
            margin: EdgeInsets.symmetric(vertical: 20),
          ),
          // Phone number
          CustomTextField(
            labeltext: "Phone number",
            controller: phoneNumberController,
            keyboardType: TextInputType.phone,
            enableBorder: false,
            hinttext: "1357908642",
            margin: EdgeInsets.only(top: 20),
            maxLength: 10,
          ),
          // Location
          CustomTextField(
            labeltext: "Nearby location",
            controller: locationController,
            enableBorder: false,
            hinttext: "City/Village",
            margin: EdgeInsets.symmetric(vertical: 20),
          ),
          // Password
          CustomTextField(
            labeltext: "Password",
            controller: passwordController,
            enableBorder: false,
            hinttext: "*********",
            margin: EdgeInsets.symmetric(vertical: 20),
            isPassword: true,
            isobscure: true,
          ),
          // Button
          CustomButton(
            title: "Sign Up",
            onTap: () async {
              try {
                emailController.text = emailController.text.trim();
                if (emailController.text.isEmpty ||
                    !emailController.text.contains("@")) {
                  return notifier("Enter a valid email", isWarning: true);
                } else if (nameController.text.isEmpty) {
                  return notifier("Enter a valid name", isWarning: true);
                } else if (phoneNumberController.text.isEmpty ||
                    (phoneNumberController.text.length != 10 &&
                        phoneNumberController.text.length != 12)) {
                  return notifier("Enter a valid phone number",
                      isWarning: true);
                } else if (locationController.text.isEmpty) {
                  return notifier("Enter a valid region", isWarning: true);
                } else if (passwordController.text.length < 8) {
                  return notifier("Password must be at least 8 characters",
                      isWarning: true);
                }
                isSigningUp = true;
                setState(() {});
                UserModel currentUser=UserModel.fromMap({
                  "email": emailController.text,
                  "name": nameController.text,
                  "phoneNumber": phoneNumberController.text,
                  "location": locationController.text
                });
                AuthRepository authService = AuthRepository();
                if (await authService.signUp(email:emailController.text, password:passwordController.text,user:currentUser)) {
                  Navigator.popAndPushNamed(context, "/home");
                }
                isSigningUp = false;
              } catch (e) {
                isSigningUp = false;
              }
              setState(() {});
            },
            margin: EdgeInsets.only(top: 20, bottom: 40),
            widget: isSigningUp ? CircularProgressIndicator.adaptive() : null,
          ),
          // Switch to register
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: RichText(
                text: TextSpan(text: "Already have an account? ", children: [
              TextSpan(
                  text: "Login",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ))
            ])),
          ),
        ],
      ),
    );
  }
}
