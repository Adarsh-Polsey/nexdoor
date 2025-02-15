import 'package:flutter/material.dart';
import 'package:nexdoor/common/core/responsive/responsive.dart';
import 'package:nexdoor/features/auth/repositories/auth_repository.dart';
import 'package:nexdoor/widgets/c_button_widget.dart';
import 'package:nexdoor/widgets/c_textfield_widget.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
        body: Responsive.isMobile(context)
            ? MobileResetPasswordScreen()
            : DeskTopResetPasswordScreen());
  }
}

// Mobile screen
class MobileResetPasswordScreen extends StatefulWidget {
  const MobileResetPasswordScreen({super.key});

  @override
  State<MobileResetPasswordScreen> createState() =>
      _MobileResetPasswordScreenState();
}

class _MobileResetPasswordScreenState extends State<MobileResetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return ForgotPasswordWidget();
  }
}

// Desktop screen
class DeskTopResetPasswordScreen extends StatelessWidget {
  const DeskTopResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Flexible(flex: 3, child: SizedBox(width: double.infinity)),
        Flexible(
          flex: 3,
          child: ForgotPasswordWidget(),
        ),
        Flexible(flex: 3, child: SizedBox(width: double.infinity)),
      ],
    );
  }
}

class ForgotPasswordWidget extends StatefulWidget {
  const ForgotPasswordWidget({super.key});

  @override
  State<ForgotPasswordWidget> createState() => _ForgotPasswordWidgetState();
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget> {
  TextEditingController emailController = TextEditingController();

  AuthRepository authService = AuthRepository();
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme color = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      margin: EdgeInsets.symmetric(vertical: 60, horizontal: 25),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Reset password",
            style: TextStyle(fontSize: 30, color: color.inversePrimary),
          ),
          SizedBox(height: 40),
          // Username
          CustomTextField(
            labeltext: "Email",
            controller: emailController,
            enableBorder: false,
            hinttext: "Enter your mail",
            margin: EdgeInsets.symmetric(vertical: 20),
          ),
          // Button
          CustomButton(
            title: "Send password reset link",
            onTap: () {
              authService.resetPassword(emailController.text);
            },
            margin: EdgeInsets.only(top: 20, bottom: 40),
          ),
          // Get back to login
          GestureDetector(
            onTap: () => Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (Route<dynamic> route) => false,
            ),
            child: Text("Get Back to login",
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: color.inversePrimary)),
          )
        ],
      ),
    );
  }
}
