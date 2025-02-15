class UserModel {
  final String? uid;
  final String? imageUrl;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? location;
  final bool isVerified;
  final bool isActive;
  final bool isBusiness;
  final List<String> savedBusinesses;
  final List<String> likedProducts;
  final List<String> followedCategories;
  final List<String> likedOffers;

  UserModel({
    this.uid = "",
    this.imageUrl = "",
    this.fullName = "",
    this.email = "",
    this.phoneNumber = "",
    this.location = "",
    this.isVerified = false,
    this.isActive = true,
    this.isBusiness=false,
    this.savedBusinesses = const [],
    this.likedProducts = const [],
    this.followedCategories = const [],
    this.likedOffers = const [],
  });

  // Convert UserModel to a Map for Firestore or JSON
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'imageUrl': imageUrl,
      'full_name': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'location': location,
      'isVerified': isVerified,
      'isActive': isActive,
      'isBusiness': isBusiness,
      'savedBusinesses': savedBusinesses,
      'likedProducts': likedProducts,
      'followedCategories': followedCategories,
      'likedOffers': likedOffers,
    };
  }

  // Create a UserModel from a Map (Firestore or JSON)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      imageUrl: map['imageUrl'],
      fullName: map['full_name'],
      email: map['email'],
      phoneNumber: map['phone_number'],
      location: map['location'],
      isVerified: map['is_verified'] ?? false,
      isActive: map['is_active'] ?? true,
      isBusiness: map['is_business'] ?? false,
      savedBusinesses: List<String>.from(map['savedBusinesses'] ?? []),
      likedProducts: List<String>.from(map['liked_products'] ?? []),
      followedCategories: List<String>.from(map['followedCategories'] ?? []),
      likedOffers: List<String>.from(map['likedOffers'] ?? []),
    );
  }

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'imageUrl': imageUrl,
      'full_name': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'location': location,
      'isVerified': isVerified,
      'isActive': isActive,
      'savedBusinesses': savedBusinesses,
      'likedProducts': likedProducts,
      'followedCategories': followedCategories,
      'likedOffers': likedOffers,
    };
  }

  // Create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      imageUrl: json['imageUrl'],
      fullName: json['full_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      location: json['location'],
      isVerified: json['is_verified'] ?? false,
      isActive: json['is_active'] ?? true,
      isBusiness: json['is_business'] ?? false,
      savedBusinesses: List<String>.from(json['saved_businesses'] ?? []),
      likedProducts: List<String>.from(json['liked_products'] ?? []),
      followedCategories: List<String>.from(json['followed_categories'] ?? []),
      likedOffers: List<String>.from(json['liked_offers'] ?? []),
    );
  }
}