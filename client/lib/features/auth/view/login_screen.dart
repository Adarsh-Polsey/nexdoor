
import 'package:flutter/material.dart';
import 'package:nexdoor/core/responsive/responsive.dart';
import 'package:nexdoor/features/auth/repositories/auth_repository.dart';
import 'package:nexdoor/widgets/c_button_widget.dart';
import 'package:nexdoor/widgets/c_textfield_widget.dart';

class LoginScreen extends StatelessWidget {
  const  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (Responsive.isMobile(context)) {
      return Scaffold(body: const MobileLoginScreen());
    } else {
      return Scaffold(body: const DeskTopLoginScreen());
    }
  }
}

// Mobile screen
class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: LoginWidget(isDesktop: false),
        );
  }
}

// Desktop screen
class DeskTopLoginScreen extends StatelessWidget {
  const DeskTopLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
          children: [
              Flexible(flex: 3, child: SizedBox(width: double.infinity)),
              Flexible(flex: 3, child:
                          LoginWidget(
                  isDesktop: true,
                ),),
              Flexible(flex: 3, child: SizedBox(width: double.infinity)),
          ],
        );
  }
}

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key, required this.isDesktop});
  final bool isDesktop;

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  bool loggingIn = false;

  AuthService authService = AuthService();
@override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;
    return  Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            margin: widget.isDesktop
                ? null
                : const EdgeInsets.symmetric(vertical: 60, horizontal: 25),
            decoration: BoxDecoration(
                color: Colors.transparent,
                // border: Border.all(color: color.inversePrimary),
                borderRadius:
                    widget.isDesktop ? null : BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Welcome! Login",
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(height: 40),
                // Username
                CustomTextField(
                  labeltext: "Email",
                  controller: emailController,
                  enableBorder: false,
                  hinttext: "Enter your mail",
                  margin: const EdgeInsets.symmetric(vertical: 20),
                ),
                // Password
                CustomTextField(
                  labeltext: "Password",
                  controller: passwordController,
                  enableBorder: false,
                  hinttext: "Enter your password",
                  margin: const EdgeInsets.only(top: 20, bottom: 5),
                  isPassword: true,
                  isobscure: true,
                ),
                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/resetPassword");
                      },
                      child: const Text("Forgot Password? ")),
                ),
                // Button
                CustomButton(
                  title: "Login",
                  onTap: () async {
                    try {
                      loggingIn = true;
                      setState(() {});
                      if (await authService.signin(
                          emailController.text, passwordController.text)) {
                        Navigator.popAndPushNamed(context, "/home");
                      }
                      loggingIn = false;
                    } catch (e) {
                      loggingIn = false;
                    }
                    setState(() {});
                  },
                  widget:
                      loggingIn ? const CircularProgressIndicator.adaptive() : null,
                  margin: const EdgeInsets.only(top: 20, bottom: 40),
                ),
                // Switch to register
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, "/signup"),
                  child: RichText(
                      text: TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(color: color.inversePrimary),
                          children: [
                        TextSpan(
                            text: "Register now",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: color.inversePrimary))
                      ])),
                ),
              ],
            ),
          );
  }
}
