class UserModel {
  final String? uid;
  final String? imageUrl;
  final String? name;
  final String? email;
  final String? bio;
  final String? programme;
  final String? passingYear;
  final bool isTeacher;
  final bool isVerified;
  final bool isProfileCompleted;
  final bool isSuperUser;
  final bool isAdmin;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.bio,
    this.programme,
    this.imageUrl,
    this.passingYear,
    this.isTeacher = false,
    this.isVerified = false,
    this.isProfileCompleted = false,
    this.isSuperUser = false,
    this.isAdmin = false,
  });

  // Convert User to a Map (for Firestore or other storage)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'programme': programme,
      'passingYear': passingYear,
      'bio': bio,
      'imageUrl':imageUrl,
      'isTeacher': isTeacher,
      'isVerified': isVerified,
      'isProfileCompleted': isProfileCompleted,
      'isSuperUser': isSuperUser,
      'isAdmin': isAdmin,
    };
  }

  // Create a User from a Map (usually from Firestore)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      bio: map['bio'],
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      programme: map['programme'],
      passingYear: map['passingYear'],
      imageUrl: map['imageUrl'],
      isTeacher: (map['isTeacher'] ?? false) as bool,
      isVerified: (map['isVerified'] ?? false) as bool,
      isProfileCompleted: (map['isProfileCompleted'] ?? false) as bool,
      isSuperUser: (map['isSuperUser'] ?? false) as bool,
      isAdmin: (map['isAdmin'] ?? false) as bool,
    );
  }
}
