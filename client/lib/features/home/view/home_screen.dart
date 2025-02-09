import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nexdoor/core/theme/color_pallete.dart';
import 'package:nexdoor/widgets/c_textfield_widget.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Text(
          ' LocalEase',
          style: GoogleFonts.poppins(
              fontSize: 26, fontWeight: FontWeight.bold, color: Colors.green),
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
            icon: Icon(Icons.search,color: Colors.black,),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        // actions: [
        //   IconButton(
        //       icon: Icon(Icons.search, color: Colors.black), onPressed: () {})
        // ],
      ),
      body: Row(
        children: [
          Flexible(flex: 2,child: CustomDrawer()),
          Flexible(flex: 8,child: PostFeed()),
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

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Drawer(
        child: Column(
          children: [
            SizedBox(height: 20),
            _drawerItem(Icons.home_outlined, "Home"),
            _drawerItem(Icons.shopping_bag_outlined, "For Sale & Free"),
            _drawerItem(Icons.notifications_active_outlined, "Notifications"),
            _drawerItem(Icons.group_outlined, "Groups"),
            Expanded(child: SizedBox()),
            _drawerItem(Icons.settings_outlined, "Settings"),
            _drawerItem(Icons.help_center_outlined, "Help Center"),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: ColorPalette.secondaryColor),
      title: Text(title, style: TextStyle(fontSize: 16,)),
      onTap: () {},
    );
  }
}



class PostFeed extends StatelessWidget {
  const PostFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(12),
      children: [
        // _reminderCard(),
        SizedBox(height: 10),
        _postCard(),
        SizedBox(height: 10),
        _businessAdCard(),
      ],
    );
  }

  Widget _reminderCard() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.lightGreen[100], borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Icon(Icons.location_pin, color: Colors.green),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "You're almost there! To finish joining your neighborhood, verify your area.",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(onPressed: () {}, child: Text("Verify", style: TextStyle(color: Colors.green)))
        ],
      ),
    );
  }

  Widget _postCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(child: Text("A")),
            title: Text("A. O.", style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("South West Greenfield • 8 hr ago"),
            trailing: Icon(Icons.more_vert),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Hello Everyone, Meet Ella! 🐶 Born April 20, 2017. She is a teacup Maltese/Yorkie. She weighs 3.5 pounds.",
              style: TextStyle(fontSize: 14),
            ),
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        "https://images.unsplash.com/photo-1574158622682-e40e69881006"),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12))),
          ),
          OverflowBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  icon: Icon(FontAwesomeIcons.heart, color: Colors.red),
                  onPressed: () {}),
              IconButton(icon: Icon(Icons.comment), onPressed: () {}),
              IconButton(icon: Icon(Icons.share), onPressed: () {})
            ],
          )
        ],
      ),
    );
  }

  Widget _businessAdCard() {
    return Card(
      color: Colors.yellow[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.store, color: Colors.orange),
        title: Text("Own a local business?",
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
            "Create a business page to connect with neighbors and gain new customers."),
        trailing: TextButton(
            onPressed: () {},
            child: Text("Create Page", style: TextStyle(color: Colors.blue))),
      ),
    );
  }
}