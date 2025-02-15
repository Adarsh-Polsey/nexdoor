import 'package:flutter/material.dart';
import 'package:nexdoor/common/core/theme/color_pallete.dart';
import 'package:nexdoor/features/business/view/widgets/custom_popup_menu.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  String selectedCategory = "All categories";

  final List<String> categories = [
    "All categories",
    "Appliances",
    "Automotive",
    "Baby & kids",
    "Bicycles",
    "Clothing & accessories",
    "Electronics",
    "Furniture",
    "Garage sales",
    "Garden",
    "Home decor",
  ];

  String selectedBusinessType = "Any";

  final List<String> businessTypes = [
    "Any",
    "Online",
    "Physical",
    "Hybrid",
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(30),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                CustomPopupMenu(
                  onSelected: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  items: categories,
                ),
                SizedBox(width: 20),
                CustomPopupMenu(
                  onSelected: (value) {
                    setState(() {
                      selectedBusinessType = value;
                    });
                  },
                  items: businessTypes,
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          // _reminderCard(),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                mainAxisExtent: 260),
            itemBuilder: (context, index) => _postCard(),
            itemCount: 20,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
          ),
        ],
      ),
    );
  }

  Widget _postCard() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              blurRadius: 4,
              color: Colors.grey.shade300,
              spreadRadius: 2,
              offset: Offset(0, 2)),
          BoxShadow(
              blurRadius: 4,
              color: Colors.grey.shade300,
              spreadRadius: 2,
              offset: Offset(0, -2)),
        ],
        color: ColorPalette.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            child: SizedBox(
              height: 175,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
                child: Image.network(
                    fit: BoxFit.fitWidth,
                    "https://images.unsplash.com/photo-1574158622682-e40e69881006"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            child: Text("Business Name",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Container(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  margin: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      color: ColorPalette.primaryButtonSplash
                          .withValues(alpha: 0.2)),
                  child: Text(
                    "Category",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            child: Text("Street Address                -  Toooo Large might be 3 to 4 lines",maxLines: 1,overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
