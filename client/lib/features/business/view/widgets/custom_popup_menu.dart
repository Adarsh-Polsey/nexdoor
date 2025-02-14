import 'package:flutter/material.dart';

class CustomPopupMenu extends StatefulWidget {
  const CustomPopupMenu({super.key, required this.onSelected, required this.items});
  final void Function(String) onSelected;
  final List<String> items;

  @override
  State<CustomPopupMenu> createState() => _CustomPopupMenuState();
}

class _CustomPopupMenuState extends State<CustomPopupMenu> {
  String? selectedItem;
  initializeItem(){
    selectedItem = widget.items[0];
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeItem();
  }
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      borderRadius: BorderRadius.circular(12),
              onSelected: (value) {
                widget.onSelected(value);
                setState(() {
                  selectedItem = value;
                });
              },
              itemBuilder: (BuildContext context) {
                return widget.items.map((String category) {
                  return PopupMenuItem<String>(
                    value: category,
                    child: Row(
                      children: [
                        Text(category, style: TextStyle(fontSize: 16)),
                        if (selectedItem == category)
                          Icon(Icons.check, color: Colors.blue),
                      ],
                    ),
                  );
                }).toList();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Text(maxLines: 1,
                        selectedItem??"",overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12),
                      ),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
            );
  }
}