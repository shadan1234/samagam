
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  final FirebaseAuth _auth=FirebaseAuth.instance;

  Stream<User?> get user{
    return _auth.authStateChanges();
  }

  Future loginInWithEmailAndPassword(String email,String password)async{
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    }
    catch(e){
      print(e.toString());
      return null;
    }
}

  Future registerUserWithEmailAndPassword(String email,String password)async{
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
  Future signOutTheUser(){
    return _auth.signOut();
  }
  Future<void> sendVerificationLink(String email) async {
    var acs = ActionCodeSettings(
      url: 'https://wowo1-6450d.firebaseapp.com	',
      handleCodeInApp: true,
      iOSBundleId: 'com.example.ios',
      androidPackageName: 'com.example.android',
      androidInstallApp: true,
      androidMinimumVersion: '12',
    );

    print('Sending email verification to $email');
    await _auth
        .sendSignInLinkToEmail(email: email, actionCodeSettings: acs)
        .catchError((onError) =>
        print('Error sending email verification: $onError'))
        .then((value) => print('Successfully sent email verification'));

    // Note: The following check might not be necessary, as the user should already click the link to trigger the sign-in process.

    // Confirm the link is a sign-in with email link.
    if (FirebaseAuth.instance.isSignInWithEmailLink(
        'wowo1-6450d.firebaseapp.com	')) {
      try {
        final userCredential = await FirebaseAuth.instance
            .signInWithEmailLink(
            email: email,
            emailLink: 'wowo1-6450d.firebaseapp.com	');

        final emailAddress = userCredential.user?.email;

        print('Successfully signed in with email link!');
      } catch (error) {
        print('Error signing in with email link: $error');
      }
    }
  }



}