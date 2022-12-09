import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class HandyConnectFirebaseUser {
  HandyConnectFirebaseUser(this.user);
  User? user;
  bool get loggedIn => user != null;
}

HandyConnectFirebaseUser? currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<HandyConnectFirebaseUser> handyConnectFirebaseUserStream() =>
    FirebaseAuth.instance
        .authStateChanges()
        .debounce((user) => user == null && !loggedIn
            ? TimerStream(true, const Duration(seconds: 1))
            : Stream.value(user))
        .map<HandyConnectFirebaseUser>(
      (user) {
        currentUser = HandyConnectFirebaseUser(user);
        return currentUser!;
      },
    );
