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
      create: (context) {
        final viewModel = BusinessDetailsViewModel(
          BusinessRepository(),
          business,
        );
        viewModel.initializeHours(business.availableDays??[], business.availableHours??[]);
        return viewModel;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(business.name),
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
          _buildBusinessHeader(context, business),
          // _buildBusinessDetailsCard(context, business),
          // _buildServiceBookingSection(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildBusinessHeader(BuildContext context, BusinessModel business) {
    return Container(
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
    );
  }

  Widget _buildBusinessDetailsCard(BuildContext context, BusinessModel business) {
    return Card(
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
    );
  }

  Widget _buildServiceBookingSection(BuildContext context, BusinessDetailsViewModel viewModel) {
    return Card(
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
            _buildServiceDropdown(viewModel),
            if (viewModel.selectedService != null) ...[
              const SizedBox(height: 16),
              _buildSelectedServiceDetails(context, viewModel),
              const SizedBox(height: 24),
              _buildAvailableTimeSlots(context, viewModel),
              if (viewModel.errorMessage != null) ...[
                const SizedBox(height: 16),
                _buildErrorMessage(context, viewModel),
              ],
              const SizedBox(height: 24),
              _buildBookButton(context, viewModel),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildServiceDropdown(BusinessDetailsViewModel viewModel) {
    return DropdownButtonFormField<String>(
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
    );
  }

  Widget _buildSelectedServiceDetails(BuildContext context, BusinessDetailsViewModel viewModel) {
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
              Icons.currency_rupee_sharp,
              'Price',
              'Rs. ${viewModel.selectedService!.price}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableTimeSlots(BuildContext context, BusinessDetailsViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Time Slots',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (viewModel.isLoading)
          const Center(child: CircularProgressIndicator())
        else
          Column(
            children: viewModel.groupedHours.entries.map((entry) {
              final day = entry.key;
              final hours = entry.value;
              return _buildDayTimeSlots(context, viewModel, day, hours);
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildDayTimeSlots(BuildContext context, BusinessDetailsViewModel viewModel, String day, List<String> hours) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          day,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 12.0,
          children: hours.map((hour) {
            final uniqueKey = '$day-$hour'; // Create a unique key for each hour
            return ChoiceChip(
              label: Text(hour),
              selected: viewModel.selectedHour == uniqueKey,
              onSelected: (bool selected) {
                if (selected) {
                  viewModel.selectHour(uniqueKey);
                } else {
                  viewModel.selectHour(null); // Deselect if already selected
                }
              },
              backgroundColor: Theme.of(context).colorScheme.surface,
              labelStyle: TextStyle(
                color: viewModel.selectedHour == uniqueKey
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
              ),
              selectedColor: Theme.of(context).colorScheme.primary,
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildErrorMessage(BuildContext context, BusinessDetailsViewModel viewModel) {
    return Text(
      viewModel.errorMessage!,
      style: TextStyle(
        color: Theme.of(context).colorScheme.error,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildBookButton(BuildContext context, BusinessDetailsViewModel viewModel) {
    return Center(
      child: ElevatedButton(
        onPressed: viewModel.isLoading || viewModel.selectedHour == null
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