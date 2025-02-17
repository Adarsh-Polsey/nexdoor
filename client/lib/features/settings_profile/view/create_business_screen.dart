import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nexdoor/features/business/models/business_model.dart';
import 'package:nexdoor/features/settings_profile/models/services_model.dart';
import 'package:nexdoor/features/settings_profile/viewmodel/profile_viewmodel.dart';
import 'package:nexdoor/features/settings_profile/viewmodel/services_viewmodel.dart';
import 'package:provider/provider.dart';

class CreateBusinessScreen extends StatefulWidget {
  const CreateBusinessScreen({super.key});

  @override
  State<CreateBusinessScreen> createState() => _CreateBusinessScreenState();
}

class _CreateBusinessScreenState extends State<CreateBusinessScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Business controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _websiteController = TextEditingController();

  // Service controllers
  final _serviceNameController = TextEditingController();
  final _serviceDescriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _priceController = TextEditingController();

  // Business dropdowns
  String? _selectedBusinessType;
  String? _selectedCategory;
  String? _selectedLocation;
  bool _allowsDelivery = false;

  // Service availability
  final Map<String, Map<String, bool>> _availability = {
    'Monday': {},
    'Tuesday': {},
    'Wednesday': {},
    'Thursday': {},
    'Friday': {},
    'Saturday': {},
    'Sunday': {},
  };

  // Predefined lists for dropdowns
  final List<String> _businessTypes = ['Physical', 'Online', 'Hybrid'];

  final List<String> _categories = [
    'Food & Beverage',
    'Health & Beauty',
    'Home Services',
    'Professional Services',
    'Retail & Shopping',
    'Auto Services',
    'Education & Training',
    'Entertainment',
    'Pet Services',
    'Other'
  ];

  final List<String> _locations = [
    'Kozhikode Town',
    'Devagiri',
    'Kovoor',
    'Chevayoor',
    'Thondayad',
    'Pottamal',
    'Arayidathupalam'
  ];

  @override
  void initState() {
    super.initState();
    // Generate time slots from 9 AM to 6 PM
    for (var day in _availability.keys) {
      for (var hour = 9; hour <= 18; hour++) {
        String timeSlot = '${hour.toString().padLeft(2, '0')}:00';
        _availability[day]![timeSlot] = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final businessViewModel = Provider.of<ProfileViewModel>(context);
    final serviceViewModel = Provider.of<ServiceViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Business & Service'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Business Information Section
                _buildSection(
                  'Business Information',
                  [
                    _buildInputField(
                      controller: _nameController,
                      label: 'Business Name',
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Business name is required'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      label: 'Business Type',
                      value: _selectedBusinessType,
                      items: _businessTypes,
                      onChanged: (value) =>
                          setState(() => _selectedBusinessType = value),
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      label: 'Category',
                      value: _selectedCategory,
                      items: _categories,
                      onChanged: (value) =>
                          setState(() => _selectedCategory = value),
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      controller: _descriptionController,
                      label: 'Business Description',
                      maxLines: 3,
                      helperText: 'Describe your business in detail',
                    ),
                  ],
                ),
                
                // Location & Contact
                _buildSection(
                  'Location & Contact',
                  [
                    _buildDropdown(
                      label: 'Location',
                      value: _selectedLocation,
                      items: _locations,
                      onChanged: (value) =>
                          setState(() => _selectedLocation = value),
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Phone number is required';
                        }
                        if (value!.length < 10) {
                          return 'Enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      controller: _emailController,
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Email is required';
                        final emailRegex =
                            RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(value!)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      controller: _websiteController,
                      label: 'Website (Optional)',
                      keyboardType: TextInputType.url,
                      validator: (value) {
                        if (value?.isEmpty ?? true) return null;
                        final urlRegex = RegExp(
                            r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$');
                        if (!urlRegex.hasMatch(value!)) {
                          return 'Enter a valid website URL';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Delivery Available'),
                      subtitle:
                          const Text('Toggle if you offer delivery services'),
                      value: _allowsDelivery,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) =>
                          setState(() => _allowsDelivery = value),
                    ),
                  ],
                ),
                
                // Service Information
                _buildSection(
                  'Service Information',
                  [
                    _buildInputField(
                      controller: _serviceNameController,
                      label: 'Service Name',
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Service name is required'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      controller: _serviceDescriptionController,
                      label: 'Service Description',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInputField(
                            controller: _durationController,
                            label: 'Duration (minutes)',
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
                          child: _buildInputField(
                            controller: _priceController,
                            label: 'Price',
                            prefixText: '\Rs.',
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
                
                // Service Availability
                _buildSection(
                  'Service Hours',
                  [
                    ...['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
                        .map((day) => _buildDayTimeSelector(day))
                        .toList(),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Submit Button
                ElevatedButton(
                  onPressed: () => _submitForm(businessViewModel, serviceViewModel),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Create Business & Service'),
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    String? helperText,
    String? prefixText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int? maxLines,
  }) {
    return TextFormField(
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        prefixText: prefixText,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      maxLines: maxLines ?? 1,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?)? onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? '$label is required' : null,
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

  Future<void> _submitForm(ProfileViewModel businessViewModel, ServiceViewModel serviceViewModel) async {
    if (_formKey.currentState!.validate() &&
        _selectedBusinessType != null &&
        _selectedCategory != null &&
        _selectedLocation != null) {
      
      try {
        // 1. Create business first
        final business = BusinessModel(
          id: '',
          name: _nameController.text,
          description: _descriptionController.text,
          category: _selectedCategory ?? "",
          address: _selectedLocation ?? "",
          phone: _phoneController.text,
          email: _emailController.text,
          website: _websiteController.text,
          allowsDelivery: _allowsDelivery,
          ownerId: '',
          isActive: true,
          createdAt: DateTime.now(),
          businessType: _selectedBusinessType ?? "",
          location: _selectedLocation ?? "",
        );
        
        final businessResponse = await businessViewModel.createBusiness(business);
        
        if (businessResponse == true) {
          // 2. Create service after business is created
          // Create availability schedule
          final schedule = <String, List<String>>{};
          for (var day in _availability.keys) {
            schedule[day] = _availability[day]!
                .entries
                .where((entry) => entry.value)
                .map((entry) => entry.key)
                .toList();
          }

          // Create service object
          final service = Service(
            name: _serviceNameController.text,
            description: _serviceDescriptionController.text,
            duration: int.parse(_durationController.text),
            price: double.parse(_priceController.text),
            availability: schedule,
          );

          // Create service
          final serviceResponse = await serviceViewModel.createService(service);
          
          if (serviceResponse && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Business and service created successfully')),
            );
            Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to create service')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to create business')),
          );
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error occurred: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
        ),
      );
    }
  }

  @override
  void dispose() {
    // Dispose business controllers
    _nameController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    
    // Dispose service controllers
    _serviceNameController.dispose();
    _serviceDescriptionController.dispose();
    _durationController.dispose();
    _priceController.dispose();
    
    super.dispose();
  }
}