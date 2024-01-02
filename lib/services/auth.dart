import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on FirebaseUser
  MyUser? _userFromFirebase(User? user){
    return user != null ? MyUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<MyUser?> get user {
    return _auth.authStateChanges().map((User? user) => _userFromFirebase(user));
  }

  // Sign in anon
  Future signInAnon() async{
    try{
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user!;
      return _userFromFirebase(user);
    } catch(error){
      print(error.toString());
      return null;
    }
  }

  // Sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user!;
      return _userFromFirebase(user);
    } catch (error){
      print(error.toString());
      return null;
    }
  }

  // Register with email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user!;

      // create a new document for the user with the uid
      await DatabaseService(uid: user.uid).updateUserData("0", "new crew member", 100);

      return _userFromFirebase(user);
    } catch (error){
      print(error.toString());
      return null;
    }
  }

  // Sign out
  Future singOut() async{
    try{
      return await _auth.signOut();
    } catch (error){
      print(error.toString());
      return null;
    }

  }
}