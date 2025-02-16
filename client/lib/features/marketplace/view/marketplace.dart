// import 'package:flutter/material.dart';
// import 'package:nexdoor/features/marketplace/view/detailed_view.dart';
// import '../repositories/business_repository.dart';
// import '../models/business_model.dart';

// class BusinessFeedView extends StatefulWidget {
//   const BusinessFeedView({super.key});

//   @override
//   _BusinessFeedViewState createState() => _BusinessFeedViewState();
// }

// class _BusinessFeedViewState extends State<BusinessFeedView> {
//   final BusinessRepository _repository = BusinessRepository();
//   List<BusinessModel> _businesses = [];
//   bool _isLoading = true;
//   String? _searchQuery;

//   @override
//   void initState() {
//     super.initState();
//     _fetchBusinesses();
//   }

//   Future<void> _fetchBusinesses() async {
//     try {
//       List<BusinessModel> businesses =
//           await _repository.fetchBusinesses(search: _searchQuery);
//       setState(() {
//         _businesses = businesses;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error loading businesses: $e")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Business Feed"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _fetchBusinesses,
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _businesses.isEmpty
//               ? const Center(child: Text("No businesses found"))
//               : ListView.builder(
//                   itemCount: _businesses.length,
//                   itemBuilder: (context, index) {
//                     final business = _businesses[index];
//                     return Card(
//                       child: ListTile(
//                         title: Text(business.name),
//                         subtitle: Text(business.description),
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   BusinessDetailView(business: business),
//                             ),
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }