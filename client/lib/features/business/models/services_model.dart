class ServicesModel {
  final String? id;
  final String name;
  final String description;
  final int duration;
  final double price;
  final List<String> availableDays;
  final List<String> availableHours;
  final String? businessId;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;

  ServicesModel({
    this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.price,
    required this.availableDays,
    required this.availableHours,
    this.businessId,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory ServicesModel.fromJson(Map<String, dynamic> json) {
    return ServicesModel(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      description: json['description'] ?? "",
      duration: json['duration'] ?? 0,
      price: json['price'].toDouble(),
      availableDays: List<String>.from(json['available_days'] ?? []),
      availableHours: List<String>.from(json['available_hours'] ?? []),
      businessId: json['business_id'] ?? "",
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'duration': duration,
      'price': price,
      'available_days': availableDays,
      'available_hours': availableHours,
      'business_id': businessId,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
