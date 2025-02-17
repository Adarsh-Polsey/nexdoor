class ServiceModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final int duration;
  final bool? isActive;
  final List<String> availableDays;
  final List<String> availableHours;
  final String? businessId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    this.isActive,
    required this.availableDays,
    required this.availableHours,
    this.businessId,
    this.createdAt,
    this.updatedAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      duration: json['duration'] ?? 0,
      isActive: json['is_active'] ?? true,
      availableDays: List<String>.from(json['available_days'] ?? []),
      availableHours: List<String>.from(json['available_hours'] ?? []),
      businessId: json['business_id'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'duration': duration,
      'is_active': isActive,
      'available_days': availableDays,
      'available_hours': availableHours,
      'business_id': businessId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
