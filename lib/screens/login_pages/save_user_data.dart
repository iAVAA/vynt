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

// User DATA: User(displayName: null, email: prova123@gmail.com, isEmailVerified: false, isAnonymous: false, metadata: UserMetadata(creationTime: 2024-12-03 21:25:13.547Z, lastSignInTime: 2024-12-15 10:29:19.638Z), phoneNumber: null, photoURL: null, providerData, [UserInfo(displayName: null, email: prova123@gmail.com, phoneNumber: null, photoURL: null, providerId: password, uid: prova123@gmail.com)], refreshToken: AMf, tenantId: null, uid: 5qk70DskYEhG4mgz1S2ZFw0jK9n1)