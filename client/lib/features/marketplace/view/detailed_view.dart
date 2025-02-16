// import 'package:flutter/material.dart';
// import '../models/business_model.dart';

// class BusinessDetailView extends StatelessWidget {
//   final BusinessModel business;

//   const BusinessDetailView({super.key, required this.business});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(business.name)),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               business.name,
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Text("Category: ${business.category}",
//                 style: const TextStyle(fontSize: 18)),
//             const SizedBox(height: 10),
//             Text("Description: ${business.description}",
//                 style: const TextStyle(fontSize: 16)),
//           ],
//         ),
//       ),
//     );
//   }
// }