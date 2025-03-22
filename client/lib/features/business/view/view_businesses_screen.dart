import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:nexdoor/features/business/view/view_detailed_business.dart';
import 'package:provider/provider.dart';
import 'package:nexdoor/common/core/theme/color_pallete.dart';
import 'package:nexdoor/features/business/repositories/business_repository.dart';
import 'package:nexdoor/features/business/models/business_model.dart';

class BusinessListViewModel extends ChangeNotifier {
  final BusinessRepository _repository;
  
  List<BusinessModel> _businesses = [];
  List<BusinessModel> _filteredBusinesses = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedCategory = "All Categories";
  String _selectedBusinessType = "Any";

  BusinessListViewModel(this._repository);

  // Getters
  List<BusinessModel> get businesses => _filteredBusinesses;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  String get selectedBusinessType => _selectedBusinessType;
  String get searchQuery => _searchQuery;

  Future<void> fetchBusinesses({
    String? search, 
    String? category, 
    String? businessType
  }) async {
    try {
      _isLoading = true;
      _searchQuery = search ?? _searchQuery;
      _selectedCategory = category ?? _selectedCategory;
      _selectedBusinessType = businessType ?? _selectedBusinessType;
      notifyListeners();

      // Fetch all businesses
      _businesses = await _repository.fetchBusinesses(search: _searchQuery);
      
      // Apply filters
      _applyFilters();

      _isLoading = false;
    } catch (e) {
      log("Error fetching businesses: $e");
      _isLoading = false;
      _businesses = [];
      _filteredBusinesses = [];
    } finally {
      notifyListeners();
    }
  }

  void _applyFilters() {
    _filteredBusinesses = _businesses.where((business) {
      // Category filter
      bool matchesCategory = _selectedCategory == "All Categories" || 
                              business.category == _selectedCategory;
      
      // Business type filter
      bool matchesBusinessType = _selectedBusinessType == "Any" || 
                                  business.businessType == _selectedBusinessType;
      
      // Search filter
      bool matchesSearch = _searchQuery.isEmpty || 
                            business.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                            business.category.toLowerCase().contains(_searchQuery.toLowerCase());
      
      return matchesCategory && matchesBusinessType && matchesSearch;
    }).toList();

    notifyListeners();
  }

  void updateFilters({
    String? category, 
    String? businessType, 
    String? search
  }) {
    if (category != null) _selectedCategory = category;
    if (businessType != null) _selectedBusinessType = businessType;
    if (search != null) _searchQuery = search;

    _applyFilters();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = "All Categories";
    _selectedBusinessType = "Any";
    _applyFilters();
  }
}
class ViewBusinessScreen extends StatefulWidget {
  const ViewBusinessScreen({super.key});

  @override
  State<ViewBusinessScreen> createState() => _ViewBusinessScreenState();
}

class _ViewBusinessScreenState extends State<ViewBusinessScreen> {
  final TextEditingController _searchController = TextEditingController();

 final List<String> categories = [
  "All Categories",
  "Health & Beauty",
  "Home Services",
  "Automotive",
  "Baby & Kids",
  "Bicycles & Repair",
  "Education & Coaching",
  "Events & Entertainment",
  "Professional Services",
  "Medical & Wellness"
];

  final List<String> businessTypes = [
    "Any",
    "Online",
    "Physical",
    "Hybrid",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BusinessListViewModel>(context, listen: false).fetchBusinesses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search and Filter Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Search TextField
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search businesses...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: Consumer<BusinessListViewModel>(
                          builder: (context, viewModel, child) {
                            return viewModel.searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    viewModel.updateFilters(search: '');
                                  },
                                )
                              : SizedBox.shrink();
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) {
                        Provider.of<BusinessListViewModel>(context, listen: false)
                            .updateFilters(search: value);
                      },
                    ),
                  ),
                  
                  // Clear Filters Button
                  Consumer<BusinessListViewModel>(
                    builder: (context, viewModel, child) {
                      return (viewModel.selectedCategory != "All Categories" ||
                             viewModel.selectedBusinessType != "Any" ||
                             viewModel.searchQuery.isNotEmpty)
                        ? IconButton(
                            icon: const Icon(Icons.filter_alt_off),
                            onPressed: () {
                              _searchController.clear();
                              viewModel.clearFilters();
                            },
                          )
                        : const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),

            // Filters Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Category Dropdown
                    _buildDropdownFilter(
                      items: categories,
                      value: context.watch<BusinessListViewModel>().selectedCategory,
                      hint: 'Category',
                      onChanged: (value) {
                        Provider.of<BusinessListViewModel>(context, listen: false)
                            .updateFilters(category: value);
                      },
                    ),
                    const SizedBox(width: 10),
                    // Business Type Dropdown
                    _buildDropdownFilter(
                      items: businessTypes,
                      value: context.watch<BusinessListViewModel>().selectedBusinessType,
                      hint: 'Business Type',
                      onChanged: (value) {
                        Provider.of<BusinessListViewModel>(context, listen: false)
                            .updateFilters(businessType: value);
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Business List
            Expanded(
              child: Consumer<BusinessListViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (viewModel.businesses.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('No businesses found'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => viewModel.clearFilters(),
                            child: const Text('Clear Filters'),
                          ),
                        ],
                      ),
                    );
                  }

                  return _buildBusinessGrid(viewModel);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownFilter({
    required List<String> items,
    required String? value,
    required String hint,
    required Function(String?) onChanged,
  }) {
    return DropdownButton<String>(
      value: value,
      hint: Text(hint),
      underline: Container(), // Remove underline
      style: TextStyle(
        color: Theme.of(context).textTheme.bodyLarge?.color,
        fontSize: 14,
      ),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: const TextStyle(overflow: TextOverflow.ellipsis),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildBusinessGrid(BusinessListViewModel viewModel) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        mainAxisExtent: 260,
      ),
      itemBuilder: (context, index) {
        return _buildBusinessCard(viewModel.businesses[index]);
      },
      itemCount: viewModel.businesses.length,
    );
  }

  Widget _buildBusinessCard(BusinessModel business) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BusinessDetailScreen()
          )
        );
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: Colors.grey.shade300,
              spreadRadius: 2,
              offset: const Offset(0, 2)
            ),
          ],
          color: ColorPalette.backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 175,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12)
                ),
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              child: const Center(
                child: Icon(Icons.business_outlined, size: 100),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
              child: Text(
                business.name,
                style: const TextStyle(fontWeight: FontWeight.bold)
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                color: ColorPalette.primaryButtonSplash.withValues(alpha: 0.2)
              ),
              child: Text(
                business.category,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
              child: Text(
                "📍${business.location}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold)
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Provider Setup
class BusinessListProvider extends StatelessWidget {
  final Widget child;

  const BusinessListProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BusinessListViewModel(BusinessRepository()),
      child: child,
    );
  }
}