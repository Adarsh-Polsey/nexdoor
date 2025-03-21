import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nexdoor/features/business/models/services_model.dart';
import 'package:nexdoor/features/settings_profile/viewmodel/service_viewmodel.dart';
import 'package:provider/provider.dart';

class AddServiceScreen extends StatefulWidget {
  final String? businessId; // Optional business ID if adding service to an existing business

  const AddServiceScreen({Key? key, this.businessId}) : super(key: key);

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _priceController = TextEditingController();

  // Availability tracking
  final Map<String, List<String>> _availability = {
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
    'Friday': [],
    'Saturday': [],
    'Sunday': [],
  };

  // Time slot generation
  List<String> _generateTimeSlots() {
    List<String> timeSlots = [];
    for (int hour = 9; hour <= 18; hour++) {
      timeSlots.add('${hour.toString().padLeft(2, '0')}:00');
    }
    return timeSlots;
  }

  @override
  Widget build(BuildContext context) {
    final serviceViewModel = Provider.of<ServiceViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.businessId != null 
          ? 'Add Service to Business' 
          : 'Create New Service'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildServiceDetailsCard(),
                const SizedBox(height: 16),
                _buildAvailabilityCard(),
                const SizedBox(height: 16),
                _buildSubmitButton(serviceViewModel),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceDetailsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Service Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Service Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Service Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) => 
                value == null || value.trim().isEmpty 
                  ? 'Service name is required' 
                  : null,
            ),
            const SizedBox(height: 16),
            // Description (Optional)
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            // Duration and Price
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _durationController,
                    decoration: const InputDecoration(
                      labelText: 'Duration (minutes)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Duration is required';
                      }
                      final duration = int.parse(value);
                      if (duration < 15) {
                        return 'Minimum 15 minutes';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      prefixText: 'Rs. ',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Price is required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailabilityCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Service Availability',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Day-wise availability
            ..._availability.keys.map((day) => _buildDayAvailabilityRow(day)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDayAvailabilityRow(String day) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: _availability[day]!.isNotEmpty,
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    // Add default time slots
                    _availability[day] = _generateTimeSlots();
                  } else {
                    _availability[day]!.clear();
                  }
                });
              },
            ),
            Text(day),
          ],
        ),
        if (_availability[day]!.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _generateTimeSlots().map((timeSlot) {
              final isSelected = _availability[day]!.contains(timeSlot);
              return ChoiceChip(
                label: Text(timeSlot),
                selected: isSelected,
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      if (!_availability[day]!.contains(timeSlot)) {
                        _availability[day]!.add(timeSlot);
                      }
                    } else {
                      _availability[day]!.remove(timeSlot);
                    }
                  });
                },
              );
            }).toList(),
          ),
        const Divider(),
      ],
    );
  }

  Widget _buildSubmitButton(ServiceViewModel serviceViewModel) {
    return ElevatedButton(
      onPressed: () => _submitForm(serviceViewModel),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Text('Add Service'),
    );
  }

  Future<void> _submitForm(ServiceViewModel serviceViewModel) async {
    if (_formKey.currentState!.validate()) {
      // Collect available days
      final availableDays = _availability.entries
          .where((entry) => entry.value.isNotEmpty)
          .map((entry) => entry.key)
          .toList();

      // Collect available hours
      final availableHours = _availability.entries
          .expand((entry) => entry.value)
          .toList();

      // Create service object
      final service = ServiceModel(
        id: "", // Backend will generate
        businessId: widget.businessId ?? "", // Use provided business ID or empty
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        duration: int.parse(_durationController.text),
        price: double.parse(_priceController.text),
        availableDays: availableDays,
        availableHours: availableHours,
      );

      // Attempt to create service
      final success = await serviceViewModel.createService(service);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service added successfully')),
        );
        Navigator.pop(context, service);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              serviceViewModel.errorMessage ?? 'Failed to add service'
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}