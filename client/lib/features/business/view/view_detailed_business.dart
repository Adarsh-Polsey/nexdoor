// UI Components
// business_details_screen.dart
import 'package:flutter/material.dart';
import 'package:nexdoor/features/business/models/business_model.dart';
import 'package:nexdoor/features/business/repositories/business_repository.dart';
import 'package:nexdoor/features/business/viewmodel/business_details_viewmodel.dart';
import 'package:provider/provider.dart';

class BusinessDetailsScreen extends StatelessWidget {
  final BusinessModel business;

  const BusinessDetailsScreen({super.key, required this.business});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BusinessDetailsViewModel(
        BusinessRepository(),
        business,
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: const BusinessDetailsContent(),
      ),
    );
  }
}

class BusinessDetailsContent extends StatelessWidget {
  const BusinessDetailsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<BusinessDetailsViewModel>(context);
    final business = viewModel.business;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Business Image/Header
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha:0.1),
            ),
            child: Center(
              child: Text(
                business.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          // Business Details Card
          Card(
            margin: const EdgeInsets.all(16),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Business Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(business.description),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.category, 'Category', business.category),
                  _buildInfoRow(Icons.business, 'Type', business.businessType),
                  _buildInfoRow(Icons.location_on, 'Location', business.location),
                  _buildInfoRow(Icons.home, 'Address', business.address),
                  _buildInfoRow(Icons.phone, 'Phone', business.phone),
                  _buildInfoRow(Icons.email, 'Email', business.email),
                  _buildInfoRow(Icons.web, 'Website', business.website),
                  _buildInfoRow(
                    Icons.local_shipping,
                    'Delivery',
                    business.allowsDelivery ? 'Available' : 'Not Available',
                  ),
                ],
              ),
            ),
          ),
          
          // Service Booking Section
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Book a Service',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 16),
                  
                  // Service Dropdown
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Select Service',
                      border: OutlineInputBorder(),
                    ),
                    value: viewModel.selectedServiceId,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        viewModel.selectService(newValue);
                      }
                    },
                    items: business.services.map<DropdownMenuItem<String>>((service) {
                      return DropdownMenuItem<String>(
                        value: service.id,
                        child: Text(service.name),
                      );
                    }).toList(),
                  ),
                  
                  // Selected Service Details
                  if (viewModel.selectedService != null) ...[
                    const SizedBox(height: 16),
                    Card(
                      color: Theme.of(context).colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              viewModel.selectedService!.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              Icons.access_time,
                              'Duration',
                              '${viewModel.selectedService!.duration} minutes',
                            ),
                            _buildInfoRow(
                              Icons.attach_money,
                              'Price',
                              'Rs. ${viewModel.selectedService!.price}',
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Available Hours
                    const SizedBox(height: 24),
                    const Text(
                      'Select Time Slot',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (viewModel.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 12.0,
                        children: viewModel.availableHours.map((hour) {
                          final isUnavailable = viewModel.unavailableHours.contains(hour);
                          return ChoiceChip(
                            label: Text(hour),
                            selected: viewModel.selectedHour == hour,
                            onSelected: isUnavailable
                                ? null
                                : (bool selected) {
                                    if (selected) {
                                      viewModel.selectHour(hour);
                                    }
                                  },
                            backgroundColor: isUnavailable 
                                ? Colors.grey.shade300 
                                : Theme.of(context).colorScheme.surface,
                            labelStyle: TextStyle(
                              color: isUnavailable
                                  ? Colors.grey.shade700
                                  : viewModel.selectedHour == hour
                                      ? Colors.white
                                      : Theme.of(context).colorScheme.onSurface,
                            ),
                            selectedColor: Theme.of(context).colorScheme.primary,
                          );
                        }).toList(),
                      ),
                      
                    // Error Message
                    if (viewModel.errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        viewModel.errorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                    
                    // Book Button
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: viewModel.isLoading
                            ? null
                            : () async {
                                final success = await viewModel.bookService();
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Booking created successfully'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else if (viewModel.errorMessage != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(viewModel.errorMessage!),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          viewModel.isLoading ? 'Booking...' : 'Book Service',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}