import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nexdoor/features/business/models/services_model.dart';
import 'package:nexdoor/features/settings_profile/viewmodel/services_viewmodel.dart';
import 'package:provider/provider.dart';

class ManageServiceScreen extends StatefulWidget {
  final String? serviceId; // Optional - if null, load the user's first service

  const ManageServiceScreen({this.serviceId, super.key});

  @override
  State<ManageServiceScreen> createState() => _ManageServiceScreenState();
}

class _ManageServiceScreenState extends State<ManageServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _priceController = TextEditingController();
  
  bool _isLoading = true;
  bool _isUpdating = false;
  ServiceModel? _currentService;

  // Time slots for each day
  final Map<String, Map<String, bool>> _availability = {
    'Monday': {},
    'Tuesday': {},
    'Wednesday': {},
    'Thursday': {},
    'Friday': {},
    'Saturday': {},
    'Sunday': {},
  };

  @override
  void initState() {
    super.initState();
    // Initialize time slots from 9 AM to 6 PM
    for (var day in _availability.keys) {
      for (var hour = 9; hour <= 18; hour++) {
        String timeSlot = '${hour.toString().padLeft(2, '0')}:00';
        _availability[day]![timeSlot] = false;
      }
    }
    
    // Load service data after widget is inserted into the tree
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadServiceData();
    });
  }

  Future<void> _loadServiceData() async {
    final serviceViewModel = Provider.of<ServiceViewModel>(context, listen: false);
    
    try {
      ServiceModel service;
      if (widget.serviceId != null) {
        // Load specific service by ID
        service = await serviceViewModel.getServiceById(widget.serviceId!);
      } else {
        // Load the first service for the current user
        final services = await serviceViewModel.getServices();
        if (services.isEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No services found. Create a new service instead.')),
            );
            Navigator.pop(context);
          }
          return;
        }
        service = services.first;
      }
      
      // Populate form fields
      _populateFormFields(service);
      
      setState(() {
        _currentService = service;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load service: ${e.toString()}')),
        );
        Navigator.pop(context);
      }
    }
  }

  void _populateFormFields(ServiceModel service) {
    _nameController.text = service.name;
    _descriptionController.text = service.description;
    _durationController.text = service.duration.toString();
    _priceController.text = service.price.toString();
    
    // Set availability
    if (service.availableDays.isNotEmpty && service.availableHours.isNotEmpty) {
      for (var i = 0; i < service.availableDays.length; i++) {
        String day = service.availableDays[i];
        List<String> hours = service.availableHours;
        
        // Mark hours as available
        for (var hour in hours) {
          if (_availability[day]!.containsKey(hour)) {
            _availability[day]![hour] = true;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Service'),
        elevation: 0,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildServiceDetailsSection(),
                    const SizedBox(height: 24),
                    _buildAvailabilitySection(),
                    const SizedBox(height: 24),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  Widget _buildServiceDetailsSection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
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
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Service Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Service name is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
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
                      if (value?.isEmpty ?? true) return 'Duration is required';
                      if (int.parse(value!) < 15) {
                        return 'Minimum duration is 15 minutes';
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
                      prefixText: '\Rs.',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Price is required';
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

  Widget _buildAvailabilitySection() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Service Hours',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
                .map((day) => _buildDayTimeSelector(day))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDayTimeSelector(String day) {
    bool isAvailable = _availability[day]!.containsValue(true);
    TimeOfDay? startTime;
    TimeOfDay? endTime;

    // Find the first and last selected time slots
    if (isAvailable) {
      List<String> selectedSlots = _availability[day]!
          .entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();

      if (selectedSlots.isNotEmpty) {
        startTime = _convertStringToTimeOfDay(selectedSlots.first);
        endTime = _convertStringToTimeOfDay(selectedSlots.last);
      }
    }

    return Column(
      children: [
        SwitchListTile(
          title: Text(day),
          value: isAvailable,
          onChanged: (bool value) {
            setState(() {
              if (value) {
                // Default to 9 AM - 5 PM when enabling
                _setDayAvailability(day, TimeOfDay(hour: 9, minute: 0),
                    TimeOfDay(hour: 17, minute: 0));
              } else {
                // Clear all time slots
                _availability[day]!.updateAll((key, value) => false);
              }
            });
          },
        ),
        if (isAvailable) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: startTime ?? TimeOfDay(hour: 9, minute: 0),
                      );
                      if (time != null) {
                        setState(() {
                          _setDayAvailability(
                              day, time, endTime ?? TimeOfDay(hour: 17, minute: 0));
                        });
                      }
                    },
                    child: Text(startTime?.format(context) ?? 'Start Time'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('to'),
                ),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: endTime ?? TimeOfDay(hour: 17, minute: 0),
                      );
                      if (time != null) {
                        setState(() {
                          _setDayAvailability(
                              day, startTime ?? TimeOfDay(hour: 9, minute: 0), time);
                        });
                      }
                    },
                    child: Text(endTime?.format(context) ?? 'End Time'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
        const Divider(),
      ],
    );
  }

  void _setDayAvailability(String day, TimeOfDay start, TimeOfDay end) {
    // Clear existing selections
    _availability[day]!.updateAll((key, value) => false);

    // Set new time range
    int startHour = start.hour;
    int endHour = end.hour;

    for (int hour = startHour; hour <= endHour; hour++) {
      String timeSlot = '${hour.toString().padLeft(2, '0')}:00';
      if (_availability[day]!.containsKey(timeSlot)) {
        _availability[day]![timeSlot] = true;
      }
    }
  }

  TimeOfDay _convertStringToTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isUpdating ? null : _updateService,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: _isUpdating
            ? const CircularProgressIndicator()
            : const Text('Update Service'),
      ),
    );
  }

  Future<void> _updateService() async {
    if (_formKey.currentState!.validate() && _currentService != null) {
      setState(() {
        _isUpdating = true;
      });

      try {
        final serviceViewModel = Provider.of<ServiceViewModel>(context, listen: false);
        
        // Create availability schedule
        final Map<String, List<String>> schedule = {};
        List<String> availableDays = [];

        for (var day in _availability.keys) {
          List<String> availableHours = _availability[day]!
              .entries
              .where((entry) => entry.value)
              .map((entry) => entry.key)
              .toList();
          
          if (availableHours.isNotEmpty) {
            availableDays.add(day);
            schedule[day] = availableHours;
          }
        }

        // Create updated service object
        final updatedService = ServiceModel(
          id: _currentService!.id,
          name: _nameController.text,
          description: _descriptionController.text,
          duration: int.parse(_durationController.text),
          price: double.parse(_priceController.text),
          availableDays: availableDays,
          availableHours: schedule.values.expand((hours) => hours).toList(),
        );

        // Update via ViewModel
        final success = await serviceViewModel.updateService(updatedService);
        
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Service updated successfully')),
          );
          Navigator.pop(context);
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update service')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating service: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isUpdating = false;
          });
        }
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