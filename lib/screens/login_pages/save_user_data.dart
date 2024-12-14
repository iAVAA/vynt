import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> saveUserData(User? user) async {
  if (user == null) return;

  DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

  DocumentSnapshot userDoc = await userRef.get();

  if (!userDoc.exists) {
    await userRef.set({
      'uid': user.uid,
      'email': user.email,
      'name': user.displayName ?? 'Anonymous',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}