import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nexdoor/common/core/theme/color_pallete.dart';
import 'package:nexdoor/features/business/repositories/business_repository.dart';
import 'package:nexdoor/features/business/view/view_detailed_business.dart';
import 'package:nexdoor/features/business/view/widgets/custom_popup_menu.dart';
import 'package:nexdoor/features/business/models/business_model.dart';

class ViewBusinessScreen extends StatefulWidget {
  const ViewBusinessScreen({super.key});

  @override
  State<ViewBusinessScreen> createState() => _ViewBusinessScreenState();
}

class _ViewBusinessScreenState extends State<ViewBusinessScreen> {
  String selectedCategory = "All categories";
  final BusinessRepository _repository = BusinessRepository();
  List<BusinessModel> _businesses = [];
  bool _isLoading = true;
  String? _searchQuery;
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
  void initState() {
    super.initState();
    _fetchBusinesses();
  }

  Future<void> _fetchBusinesses() async {
    try {
      log("Fetching business");
      List<BusinessModel> businesses =
          await _repository.fetchBusinesses(search: _searchQuery);
      log("Fetched business");
          log("Businesses : $businesses");
      setState(() {
        _businesses = businesses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _businesses.isEmpty
            ? const Center(child: Text("No businesses found"))
            : SingleChildScrollView(
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
                      itemBuilder: (context, index) {
                        return _postCard(_businesses[index]);
                      },
                      itemCount: _businesses.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                    ),
                  ],
                ),
              );
  }

  Widget _postCard(BusinessModel business) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(builder: (context) => BusinessDetailsScreen(business: business)));
      },
      child: Container(
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
                  child: Icon(Icons.business_outlined, size: 100),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
              child: Text(business.name,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
              margin: EdgeInsets.all(3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color:
                      ColorPalette.primaryButtonSplash.withValues(alpha: 0.2)),
              child: Text(
                business.category,
                style: TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
              child: Text("📍${business.location}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
