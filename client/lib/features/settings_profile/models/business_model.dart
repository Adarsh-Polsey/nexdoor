class Business {
  final String id;
  final String name;
  final String description;
  final String category;
  final String address;
  final String phone;
  final String email;
  final String website;
  final bool allowsDelivery;
  final String ownerId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Business({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.address,
    required this.phone,
    required this.email,
    required this.website,
    required this.allowsDelivery,
    required this.ownerId,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  // ✅ Convert JSON to Business object
  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      website: json['website'],
      allowsDelivery: json['allows_delivery'],
      ownerId: json['owner_id'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  // ✅ Convert Business object to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "category": category,
      "address": address,
      "phone": phone,
      "email": email,
      "website": website,
      "allows_delivery": allowsDelivery,
      "owner_id": ownerId,
      "is_active": isActive,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }
}