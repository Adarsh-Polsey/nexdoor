import 'package:nexdoor/features/business/models/services_model.dart';

class BusinessModel {
  final String? id;
  final String name;
  final String description;
  final String category;
  final String businessType;
  final String location;
  final String address;
  final String phone;
  final String email;
  final String website;
  final bool allowsDelivery;
  final String? ownerId;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;
  final List<ServicesModel> services;

  BusinessModel({
    this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.businessType,
    required this.location,
    required this.address,
    required this.phone,
    required this.email,
    required this.website,
    required this.allowsDelivery,
    this.ownerId,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    required this.services,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      description: json['description'] ?? "",
      category: json['category'] ?? "",
      businessType: json['business_type'] ?? "",
      location: json['location'] ?? "",
      address: json['address'] ?? "",
      phone: json['phone'] ?? "",
      email: json['email'] ?? "",
      website: json['website'] ?? "",
      allowsDelivery: json['allows_delivery'] ?? false,
      ownerId: json['owner_id'] ?? "",
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      services: (json['services'] as List)
          .map((service) => ServicesModel.fromJson(service))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'business_type': businessType,
      'location': location,
      'address': address,
      'phone': phone,
      'email': email,
      'website': website,
      'allows_delivery': allowsDelivery,
      'owner_id': ownerId,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'services': services.map((service) => service.toJson()).toList(),
    };
  }
}
