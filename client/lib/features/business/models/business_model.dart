import 'package:nexdoor/features/business/models/services_model.dart';

class BusinessModel {
  final String? id;
  final String name;
  final String description;
  final String category;
  final String address;
  final String phone;
  final String email;
  final String website;
  final bool allowsDelivery;
  final String? ownerId;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String businessType;
  final String location;
  final List<ServiceModel> services;
  final List<String>? availableDays; // New field
  final List<String>? availableHours; // New field

  BusinessModel({
    this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.address,
    required this.phone,
    required this.email,
    required this.website,
    required this.allowsDelivery,
    this.ownerId,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    required this.businessType,
    required this.location,
    required this.services,
     this.availableDays, // Initialize new field
     this.availableHours, // Initialize new field
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      website: json['website'] ?? '',
      allowsDelivery: json['allows_delivery'] ?? false,
      ownerId: json['owner_id'] ?? '',
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      businessType: json['business_type'] ?? '',
      location: json['location'] ?? '',
      services: (json['services'] as List<dynamic>?)
              ?.map((service) => ServiceModel.fromJson(service as Map<String, dynamic>))
              .toList() ??
          [],
      availableDays: (json['available_days'] as List<dynamic>?)
              ?.map((day) => day.toString())
              .toList() ??
          [], // Parse available_days
      availableHours: (json['available_hours'] as List<dynamic>?)
              ?.map((hour) => hour.toString())
              .toList() ??
          [], // Parse available_hours
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'address': address,
      'phone': phone,
      'email': email,
      'website': website,
      'allows_delivery': allowsDelivery,
      'owner_id': ownerId,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'business_type': businessType,
      'location': location,
      'services': services.map((s) => s.toJson()).toList(),
      'available_days': availableDays, // Include available_days in JSON
      'available_hours': availableHours, // Include available_hours in JSON
    };
  }
}