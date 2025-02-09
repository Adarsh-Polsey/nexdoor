import 'package:flutter/material.dart';
import 'package:nexdoor/features/auth/repositories/auth_repository.dart';
import 'package:nexdoor/widgets/c_button_widget.dart';
import 'package:nexdoor/widgets/c_textfield_widget.dart';
import 'package:nexdoor/core/responsive/responsive.dart';


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
              Flexible(flex: 3, child:
                          SignUpWidget(
                  isDesktop: true,
                ),),
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
  TextEditingController passwordController = TextEditingController();
  bool isSigningUp = false;
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;
    return Container(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            margin: widget.isDesktop
                ? null
                : EdgeInsets.symmetric(vertical: 60, horizontal: 25),
            decoration: BoxDecoration(
                border: widget.isDesktop
                    ? null
                    : Border.all(color: color.secondary),
                borderRadius:
                    widget.isDesktop ? null : BorderRadius.circular(10)),
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
                  hinttext: "Enter your mail",
                  margin: EdgeInsets.symmetric(vertical: 20),
                ),
                // Password
                CustomTextField(
                  labeltext: "Password",
                  controller: passwordController,
                  enableBorder: false,
                  hinttext: "Enter your password",
                  margin: EdgeInsets.only(top: 20, bottom: 5),
                  isPassword: true,
                  isobscure: true,
                ),
                // Button
                CustomButton(
                  title: "Sign Up",
                  onTap: () async {
                    try {
                      isSigningUp = true;
                      setState(() {});
                      AuthService authService = AuthService();
                      if (await authService.signUp(
                          emailController.text, passwordController.text)) {
                        Navigator.popAndPushNamed(context, "/home");
                      }
                      isSigningUp = false;
                    } catch (e) {
                      isSigningUp = false;
                    }
                    setState(() {});
                  },
                  margin: EdgeInsets.only(top: 20, bottom: 40),
                  widget:
                      isSigningUp ? CircularProgressIndicator.adaptive() : null,
                ),
                // Switch to register
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: RichText(
                      text: TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(color: Colors.white),
                          children: [
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