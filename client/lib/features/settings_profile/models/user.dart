class UserModel {
  final String? uid;
  final String? imageUrl;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? location; // City, Country (Optional)
  final bool isVerified;
  final bool isActive;
  final List<String> savedBusinesses;
  final List<String> likedBusinesses;
  final List<String> followedCategories;
  final List<String> likedOffers;

  UserModel({
    this.uid,
    this.imageUrl,
    this.name,
    this.email,
    this.phoneNumber,
    this.location,
    this.isVerified = false,
    this.isActive = true,
    this.savedBusinesses = const [],
    this.likedBusinesses = const [],
    this.followedCategories = const [],
    this.likedOffers = const [],
  });

  // Convert UserModel to a Map for Firestore or JSON
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'imageUrl': imageUrl,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'location': location,
      'isVerified': isVerified,
      'isActive': isActive,
      'savedBusinesses': savedBusinesses,
      'likedBusinesses': likedBusinesses,
      'followedCategories': followedCategories,
      'likedOffers': likedOffers,
    };
  }

  // Create a UserModel from a Map (Firestore or JSON)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      imageUrl: map['imageUrl'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      location: map['location'],
      isVerified: map['isVerified'] ?? false,
      isActive: map['isActive'] ?? true,
      savedBusinesses: List<String>.from(map['savedBusinesses'] ?? []),
      likedBusinesses: List<String>.from(map['likedBusinesses'] ?? []),
      followedCategories: List<String>.from(map['followedCategories'] ?? []),
      likedOffers: List<String>.from(map['likedOffers'] ?? []),
    );
  }
}