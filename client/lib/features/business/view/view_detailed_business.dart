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
      )..fetchAvailableTimeSlots(), // Fetch time slots on initialization
      child: const Scaffold(
        body: BusinessDetailsContent(),
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
    final isWideScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(business.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Implement share functionality
              _showShareDialog(context, business);
            },
          ),
        ],
      ),
      body: isWideScreen 
        ? _buildWideScreenLayout(context, viewModel, business)
        : _buildNarrowScreenLayout(context, viewModel, business),
    );
  }

  Widget _buildWideScreenLayout(
    BuildContext context, 
    BusinessDetailsViewModel viewModel, 
    BusinessModel business
  ) {
    return Row(
      children: [
        Expanded(child: _buildBusinessDetailsSection(context, business)),
        Expanded(child: _buildServiceBookingSection(context, viewModel)),
      ],
    );
  }

  Widget _buildNarrowScreenLayout(
    BuildContext context, 
    BusinessDetailsViewModel viewModel, 
    BusinessModel business
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildBusinessDetailsSection(context, business),
          _buildServiceBookingSection(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildBusinessDetailsSection(BuildContext context, BusinessModel business) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              label: 'Business Information',
              child: const Text(
                'Business Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            _buildBusinessInfoContent(context, business),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessInfoContent(BuildContext context, BusinessModel business) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
    );
  }

  Widget _buildServiceBookingSection(
    BuildContext context, 
    BusinessDetailsViewModel viewModel
  ) {
    return Card(
      margin: const EdgeInsets.all(16),
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
            _buildServiceDropdown(context, viewModel),
            _buildSelectedServiceDetails(context, viewModel),
            _buildTimeSlotSelection(context, viewModel),
            _buildErrorMessageSection(viewModel),
            _buildBookingButton(context, viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceDropdown(
    BuildContext context, 
    BusinessDetailsViewModel viewModel
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: DropdownButtonFormField<String>(
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
        items: viewModel.business.services.map<DropdownMenuItem<String>>((service) {
          return DropdownMenuItem<String>(
            value: service.id,
            child: Text(service.name),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSelectedServiceDetails(
    BuildContext context, 
    BusinessDetailsViewModel viewModel
  ) {
    if (viewModel.selectedService == null) return const SizedBox.shrink();

    return Card(
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
    );
  }

  Widget _buildTimeSlotSelection(
    BuildContext context, 
    BusinessDetailsViewModel viewModel
  ) {
    if (viewModel.selectedService == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            'Select Time Slot',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildTimeSlotChips(context, viewModel),
      ],
    );
  }

  Widget _buildTimeSlotChips(
    BuildContext context, 
    BusinessDetailsViewModel viewModel
  ) {
    return Wrap(
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
    );
  }

  Widget _buildErrorMessageSection(BusinessDetailsViewModel viewModel) {
    return viewModel.errorMessage != null
      ? Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Container(
            padding: const EdgeInsets.all(8),
            color: Colors.red.shade100,
            child: Row(
              children: [
                const Icon(Icons.error, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(child: Text(viewModel.errorMessage!)),
              ],
            ),
          ),
        )
      : const SizedBox.shrink();
  }

  Widget _buildBookingButton(
    BuildContext context, 
    BusinessDetailsViewModel viewModel
  ) {
    return Center(
      child: ElevatedButton(
        onPressed: viewModel.isLoading || !viewModel.isBookingValid
          ? null
          : () async {
              final success = await viewModel.bookService();
              _handleBookingResult(context, success, viewModel);
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
    );
  }

  void _handleBookingResult(
    BuildContext context, 
    bool success, 
    BusinessDetailsViewModel viewModel
  ) {
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking created successfully'),
          backgroundColor: Colors.green,
        ),
      );
      // Optionally reset booking or navigate
      viewModel.resetBooking();
    } else if (viewModel.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showShareDialog(BuildContext context, BusinessModel business) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Business'),
        content: Text('Share details of ${business.name}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
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