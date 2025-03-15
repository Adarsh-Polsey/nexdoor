import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Terms and Conditions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Welcome to Nexdoor! By using our platform, you agree to the following terms and conditions. Please read them carefully before proceeding.',
            ),
            SizedBox(height: 16),
            Text(
              'Acceptance of Terms',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'By accessing or using Nexdoor, you agree to be bound by these Terms and Conditions. If you do not agree with any part of these terms, you must not use our services.',
            ),
            SizedBox(height: 16),
            Text(
              'User Responsibilities',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'You are responsible for maintaining the confidentiality of your account and password.',
            ),
            SizedBox(height: 8),
            Text(
              'You agree to provide accurate and complete information when creating an account.',
            ),
            SizedBox(height: 8),
            Text(
              'You must not use Nexdoor for any illegal or unauthorized purposes.',
            ),
            SizedBox(height: 16),
            Text(
              'Service Providers',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Service providers on Nexdoor are independent entities and not employees of Nexdoor.',
            ),
          ],
        ),
      ),
    );
  }
}