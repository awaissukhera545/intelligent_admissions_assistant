import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Service to manage extended user profile data in Firestore.
/// Stores CNIC, intermediate discipline, and profile photo URL
/// in a `users/{uid}` document.
class UserProfileService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  DocumentReference? get _userDoc =>
      _uid != null ? _db.collection('users').doc(_uid) : null;

  /// Save profile data during signup
  Future<void> createProfile({
    required String name,
    required String email,
    required String cnic,
    required String intermediateDiscipline,
    String? profilePhotoUrl,
  }) async {
    if (_userDoc == null) return;
    await _userDoc!.set({
      'name': name,
      'email': email,
      'cnic': cnic,
      'intermediateDiscipline': intermediateDiscipline,
      'profilePhotoUrl': profilePhotoUrl ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Get the user's profile data
  Future<Map<String, dynamic>?> getProfile() async {
    if (_userDoc == null) return null;
    final doc = await _userDoc!.get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>?;
    }
    return null;
  }

  /// Update specific profile fields
  Future<void> updateProfile(Map<String, dynamic> data) async {
    if (_userDoc == null) return;
    await _userDoc!.update(data);
  }

  /// Update profile photo URL
  Future<void> updateProfilePhoto(String photoUrl) async {
    if (_userDoc == null) return;
    await _userDoc!.update({'profilePhotoUrl': photoUrl});
  }

  /// Update intermediate discipline
  Future<void> updateDiscipline(String discipline) async {
    if (_userDoc == null) return;
    await _userDoc!.update({'intermediateDiscipline': discipline});
  }
}
