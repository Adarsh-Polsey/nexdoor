import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nexdoor/features/settings_profile/models/business_model.dart';
import 'package:nexdoor/features/settings_profile/viewmodel/business_viewmodel.dart';
import 'package:provider/provider.dart';

class ManageBusinessScreen extends StatefulWidget {
  const ManageBusinessScreen({super.key});

  @override
  State<ManageBusinessScreen> createState() => _ManageBusinessScreenState();
}

class _ManageBusinessScreenState extends State<ManageBusinessScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _websiteController = TextEditingController();

  String? _selectedBusinessType;
  String? _selectedCategory;
  String? _selectedLocation;
  bool _allowsDelivery = false;

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
    // Fetch business data when the screen is loaded
    Future.microtask(() => Provider.of<BusinessViewModel>(context, listen: false).fetchABusiness());
  }

  @override
  Widget build(BuildContext context) {
    final businessViewModel = Provider.of<BusinessViewModel>(context);

    // Populate form fields if business data is fetched
    if (businessViewModel.business != null && _nameController.text.isEmpty) {
      final business = businessViewModel.business!;
      _nameController.text = business.name;
      _descriptionController.text = business.description;
      _phoneController.text = business.phone;
      _emailController.text = business.email;
      _websiteController.text = business.website;
      _selectedBusinessType = business.businessType;
      _selectedCategory = business.category;
      _selectedLocation = business.location;
      _allowsDelivery = business.allowsDelivery;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Business'),
        elevation: 0,
      ),
      body: businessViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : businessViewModel.errorMessage != null
              ? Center(child: Text(businessViewModel.errorMessage!))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildSection(
                            'Basic Information',
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
                            ],
                          ),
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
                            ],
                          ),
                          _buildSection(
                            'Additional Details',
                            [
                              _buildInputField(
                                controller: _descriptionController,
                                label: 'Description',
                                maxLines: 3,
                                helperText: 'Describe your business in detail',
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
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate() &&
                                  _selectedBusinessType != null &&
                                  _selectedCategory != null &&
                                  _selectedLocation != null) {
                                final business = Business(
                                  id: businessViewModel.business?.id ?? '', // Use existing ID if editing
                                  name: _nameController.text,
                                  description: _descriptionController.text,
                                  category: _selectedCategory ?? "",
                                  businessType: _selectedBusinessType ?? "",
                                  location: _selectedLocation ?? "",
                                  address: _selectedLocation ?? "",
                                  phone: _phoneController.text,
                                  email: _emailController.text,
                                  website: _websiteController.text,
                                  allowsDelivery: _allowsDelivery,
                                  ownerId: businessViewModel.business?.ownerId ?? '', // Use existing owner ID if editing
                                  isActive: true,
                                  createdAt: businessViewModel.business?.createdAt ?? DateTime.now(), // Use existing creation date if editing
                                );

                                if (businessViewModel.business != null) {
                                  // Update existing business
                                  await businessViewModel.updateBusiness(business);
                                } else {
                                  // Create new business
                                  await businessViewModel.createBusiness(business);
                                }

                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Business saved successfully'),
                                    ),
                                  );
                                  Navigator.pop(context);
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please fill all required fields'),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Save Business'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
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
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    String? helperText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int? maxLines,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
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
}