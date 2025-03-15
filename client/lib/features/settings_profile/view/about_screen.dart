import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Nexdoor'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'About Nexdoor',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Nexdoor is a platform designed to connect neighbors and build stronger communities. Whether you need to borrow a tool, find a local service, or just chat with your neighbors, Nexdoor makes it easy.',
            ),
            SizedBox(height: 16),
            Text(
              'Version',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'App Version: 1.0.0',
            ),
            SizedBox(height: 16),
            Text(
              'Contact Us',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'If you have any questions or feedback, please feel free to reach out to us at support@nexdoor.com.',
            ),
            SizedBox(height: 16),
            Text(
              'Follow Us',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: <Widget>[
                Icon(Icons.facebook),
                SizedBox(width: 8),
                Text('Facebook'),
                SizedBox(width: 16),
                Icon(Icons.business),
                SizedBox(width: 8),
                Text('Twitter'),
                SizedBox(width: 16),
                Icon(Icons.web),
                SizedBox(width: 8),
                Text('Website'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}