import 'package:brand_shoes/models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference<UserProfile>? _userReference;

  DatabaseServices() {
    _setupFirebaseUserReference();
  }

  void _setupFirebaseUserReference() {
    _userReference =
        _firebaseFirestore.collection("users").withConverter<UserProfile>(
              fromFirestore: (snapshot, _) =>
                  UserProfile.fromJson(snapshot.data()!),
              toFirestore: (UserProfile, _) => UserProfile.toJson(),
            );
  }

  // Create a new user in Firestore
  Future<void> createRegisterUserInDatabase({
    required UserProfile userProfile,
  }) async {
    await _userReference?.doc(userProfile.uid).set(userProfile);
  }

  // Get document data for a specific user
  Future<Map?> getDocuemntData({
    required String uid,
  }) async {
    try {
      DocumentSnapshot document =
          await _firebaseFirestore.collection("users").doc(uid).get();

      if (document.exists) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        return data;
      } else {
        print('No such document!');
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Update user data in Firestore
  Future<void> updateUserData({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firebaseFirestore.collection("users").doc(uid).update(data);
      print("User data updated successfully");
    } catch (e) {
      print("Error updating user data: $e");
    }
  }
}
