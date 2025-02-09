import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nexdoor/features/auth/models/user.dart';
import 'package:nexdoor/features/auth/repositories/auth_repository.dart';

class UserDataService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to add a user
  Future<bool> addUser({UserModel? user}) async {
    try {
      UserModel currentUser = UserModel(
          uid: _auth.currentUser!.uid,
          name: user?.name,
          email: _auth.currentUser!.email,
          bio: user?.bio,
          programme: user?.programme,
          passingYear: user?.passingYear,
          isProfileCompleted: user?.isProfileCompleted ?? false,
          isVerified: _auth.currentUser!.emailVerified);
      final userDoc = currentUser.toMap();
      String userId = _auth.currentUser!.uid;
      await _db.collection('users').doc(userId).set(userDoc);
      return true;
    } catch (e, s) {
      if (e is FirebaseException) {
        handleFirestoreException(e);
      }
      errorNotifier("addUser()", e, s);
      throw (400);
    }
  }

// Updates user data with provided fields
  Future<bool> updateUser(Map<String, dynamic> user) async {
    try {
      String userId = _auth.currentUser!.uid;
      await _db.collection('users').doc(userId).update(user);
      notifier('User Profile Updated: ${user['name']}', isSuccess: true);
      return true;
    } catch (e, s) {
      if (e is FirebaseException) {
        handleFirestoreException(e);
      }
      errorNotifier("updateUser()", e, s);
      throw (400);
    }
  }

  // Fetch current user info
  Future<UserModel> fetchCurrentUserInfo() async {
    // Get the current user's ID
    User? currentUser = _auth.currentUser;
    UserModel userData;
    try {
      String uid = currentUser!.uid;
      // Query Firestore for UserInfo where uid == collection doc's ID
      DocumentSnapshot docSnapshot =
          await _db.collection('users').doc(uid).get();

      userData = UserModel.fromMap(
          docSnapshot.data() as Map<String, dynamic>); // Get the document data
      return userData;
    } catch (e, s) {
      if (e is FirebaseException) {
        handleFirestoreException(e);
      }
      errorNotifier("fetchCurrentUserInfo() - $e", e, s);
      throw (500);
    }
  }

  // Fetch Other user info
  Future<UserModel?> fetchAnotherUserInfo(String? uid) async {
    // Get the current user's ID
    UserModel? userData;
    DocumentSnapshot docSnapshot = await _db.collection('users').doc(uid).get();
    try {
      if (uid != null || docSnapshot.data() != null) {
        userData =
            UserModel.fromMap(docSnapshot.data() as Map<String, dynamic>);
      }
      return userData;
    } catch (e, s) {
      if (e is FirebaseException) {
        handleFirestoreException(e);
      }
      errorNotifier("fetchAnotherUserInfo()", e, s);
    }
    return null;
  }

  
  // Fetch all users
  Future<List> fetchUsers() async {
    List<Map<String, dynamic>> userData = [];
    try {
      final QuerySnapshot usersSnapshot = await _db.collection('users').get();
      for (var doc in usersSnapshot.docs) {
        userData.add(doc.data() as Map<String, dynamic>);
      }
      return userData;
    } catch (e, s) {
      if (e is FirebaseException) {
        handleFirestoreException(e);
      }
      errorNotifier("fetchUsers()", e, s);
      throw ();
    }
  }
}

void handleFirestoreException(FirebaseException e) {
  switch (e.code) {
    case 'cancelled':
      log("Error: Operation was cancelled.");
      break;
    case 'invalid-argument':
      log("Error: Invalid argument provided.");
      break;
    case 'not-found':
      log("Error: Document not found.");
      break;
    case 'already-exists':
      log("Error: Document already exists.");
      break;
    case 'permission-denied':
      log("Error: Permission denied.");
      break;
    case 'resource-exhausted':
      log("Error: Quota exceeded or resource exhausted.");
      break;
    case 'failed-precondition':
      log("Error: Operation cannot be executed due to unmet preconditions.");
      break;
    case 'aborted':
      log("Error: Operation was aborted.");
      break;
    case 'out-of-range':
      log("Error: Value is out of range.");
      break;
    case 'unimplemented':
      log("Error: Operation is not available.");
      break;
    case 'internal':
      log("Error: Internal server error.");
      break;
    case 'unavailable':
      log("Error: Firestore service is currently unavailable.");
      break;
    case 'deadline-exceeded':
      log("Error: Operation took too long to complete.");
      break;
    case 'data-loss':
      log("Error: Data corruption or loss occurred.");
      break;
    case 'unauthenticated':
      log("Error: The user is unauthenticated.");
      break;
    default:
      log("Error: ${e.message}");
  }
}
