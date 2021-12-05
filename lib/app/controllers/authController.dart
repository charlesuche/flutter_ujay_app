import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ujay_app/app/views/HomePage.dart';
import 'package:ujay_app/model/userModel.dart';
import '../views/Start.dart';
import 'appController.dart';

class AuthController extends GetxController {
  static AuthController to = Get.find();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Rxn<User> firebaseUser = Rxn<User>();
  Rxn<UserModel> firestoreUser = Rxn<UserModel>();
  final RxBool admin = false.obs;

  @override
  void onReady() async {
    //run every time auth state changes
    ever(firebaseUser, handleAuthChanged);

    firebaseUser.bindStream(user);

    super.onReady();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  handleAuthChanged(_firebaseUser) async {
    //get user data from firestore
    if (_firebaseUser?.uid != null) {
      firestoreUser.bindStream(streamFirestoreUser());
      await isAdmin();
    }

    if (_firebaseUser == null) {
      print('Send to signin');
      Get.offAll(Start());
    } else {
      print('Welcome');
      Get.offAll(HomePage());
    }
  }

  // Firebase user one-time fetch
  Future<User> get getUser async => _auth.currentUser!;

  // Firebase user a realtime stream
  Stream<User?> get user => _auth.authStateChanges();

  //Streams the firestore user from the firestore collection
  Stream<UserModel> streamFirestoreUser() {
    print('streamFirestoreUser()');

    return _db
        .doc('/users/${firebaseUser.value!.uid}')
        .snapshots()
        .map((snapshot) => UserModel.fromMap(snapshot.data()!));
  }

  //get the firestore user from the firestore collection
  Future<UserModel> getFirestoreUser() {
    return _db.doc('/users/${firebaseUser.value!.uid}').get().then(
        (documentSnapshot) => UserModel.fromMap(documentSnapshot.data()!));
  }

  //Method to handle user sign in using email and password
  signInWithEmailAndPassword() async {
    showLoadingIndicator();
    try {
      await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      emailController.clear();
      passwordController.clear();
      hideLoadingIndicator();
    } catch (error) {
      hideLoadingIndicator();
      Get.snackbar('Login Failed:'.tr, ' email or password incorrect'.tr,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 7),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }

  // User registration using email and password
  registerWithEmailAndPassword() async {
    showLoadingIndicator();
    try {
      await _auth
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((result) async {
        print('uID: ' + result.user!.uid.toString());
        print('email: ' + result.user!.email.toString());
        //get photo url from gravatar if user has one
        // Gravatar gravatar = Gravatar(emailController.text);
        // String gravatarUrl = gravatar.imageUrl(
        //   size: 200,
        //   defaultImage: GravatarImage.retro,
        //   rating: GravatarRating.pg,
        //   fileExtension: true,
        // );
        //create the new user object
        UserModel _newUser = UserModel(
          uid: result.user!.uid,
          email: result.user!.email!,
          name: nameController.text,
          //photoUrl: gravatarUrl
        );
        //create the user in firestore
        _createUserFirestore(_newUser, result.user!);
        emailController.clear();
        passwordController.clear();
        hideLoadingIndicator();
      });
    } on FirebaseAuthException catch (error) {
      hideLoadingIndicator();
      Get.snackbar('SignUp failed'.tr, error.message!,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 10),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }

  //handles updating the user when updating profile
  Future<void> updateUser(BuildContext context, UserModel user, String oldEmail,
      String password) async {
    String _authUpdateUserNoticeTitle = 'auth.updateUserSuccessNoticeTitle'.tr;
    String _authUpdateUserNotice = 'auth.updateUserSuccessNotice'.tr;
    try {
      //showLoadingIndicator();
      try {
        await _auth
            .signInWithEmailAndPassword(email: oldEmail, password: password)
            .then((_firebaseUser) {
          _firebaseUser.user!
              .updateEmail(user.email)
              .then((value) => _updateUserFirestore(user, _firebaseUser.user!));
        });
      } catch (err) {
        print('Caught error: $err');
        //not yet working, see this issue https://github.com/delay/flutter_starter/issues/21
        if (err ==
            "Error: [firebase_auth/email-already-in-use] The email address is already in use by another account.") {
          _authUpdateUserNoticeTitle = 'auth.updateUserEmailInUse'.tr;
          _authUpdateUserNotice = 'auth.updateUserEmailInUse'.tr;
        } else {
          _authUpdateUserNoticeTitle = 'auth.wrongPasswordNotice'.tr;
          _authUpdateUserNotice = 'auth.wrongPasswordNotice'.tr;
        }
      }
      //hideLoadingIndicator();
      Get.snackbar(_authUpdateUserNoticeTitle, _authUpdateUserNotice,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 5),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    } on PlatformException catch (error) {
      //List<String> errors = error.toString().split(',');
      // print("Error: " + errors[1]);
      //hideLoadingIndicator();
      print(error.code);
      String authError;
      switch (error.code) {
        case 'ERROR_WRONG_PASSWORD':
          authError = 'auth.wrongPasswordNotice'.tr;
          break;
        default:
          authError = 'auth.unknownError'.tr;
          break;
      }
      Get.snackbar('auth.wrongPasswordNoticeTitle'.tr, authError,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 10),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }

  //updates the firestore user in users collection
  void _updateUserFirestore(UserModel user, User _firebaseUser) {
    _db.doc('/users/${_firebaseUser.uid}').update(user.toJson());
    update();
  }

  //create the firestore user in users collection
  void _createUserFirestore(UserModel user, User _firebaseUser) {
    _db.doc('/users/${_firebaseUser.uid}').set(user.toJson());
    update();
  }

  //password reset email
  Future<void> sendPasswordResetEmail(BuildContext context) async {
    //showLoadingIndicator();
    try {
      await _auth.sendPasswordResetEmail(email: emailController.text);
      //hideLoadingIndicator();
      Get.snackbar(
          'auth.resetPasswordNoticeTitle'.tr, 'auth.resetPasswordNotice'.tr,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 5),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    } on FirebaseAuthException catch (error) {
      //hideLoadingIndicator();
      Get.snackbar('auth.resetPasswordFailed'.tr, error.message!,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 10),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    }
  }

  //check if user is an admin user
  isAdmin() async {
    await getUser.then((user) async {
      DocumentSnapshot adminRef =
          await _db.collection('admin').doc(user.uid).get();
      if (adminRef.exists) {
        admin.value = true;
      } else {
        admin.value = false;
      }
      update();
    });
  }

  // Sign out
  Future<void> signOut() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    return _auth.signOut();
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ujay_app/HomePage.dart';
// import 'package:ujay_app/auth_services/Start.dart';
// import 'package:ujay_app/auth_services/constants/firebaseCons.dart';
// import 'package:ujay_app/model/userModel.dart';

// class AuthController extends GetxController {
//   static AuthController instance = Get.find();
//   //Rx<User> firebaseUser;

//   RxBool isLoggedIn = false.obs;
//   TextEditingController name = TextEditingController();
//   TextEditingController email = TextEditingController();
//   TextEditingController password = TextEditingController();
//   String userCollection = "users";
//   Rx<UserModel> userModel = UserModel().obs;

//   // static AuthController to = Get.find();
//   // TextEditingController nameController = TextEditingController();
//   // TextEditingController emailController = TextEditingController();
//   // TextEditingController passwordController = TextEditingController();
//   // final FirebaseAuth _auth = FirebaseAuth.instance;
//    final FirebaseFirestore _db = FirebaseFirestore.instance;
//    Rxn<User> firebaseUser = Rxn<User>();
//    Rxn<UserModel> firestoreUser = Rxn<UserModel>();
//   // final RxBool admin = false.obs;

//   @override
//   void onReady() {
//     super.onReady();
//     //firebaseUser = Rx<User>(auth.currentUser);
//     firebaseUser.bindStream(auth.userChanges());
//     ever(firebaseUser, _handleAuthChanged);

//     super.onReady();
//   }

//   @override
//   void onClose() {
//     name.dispose();
//     email.dispose();
//     password.dispose();
//     super.onClose();
//   }

//   _handleAuthChanged(user) {
//     if (user?.uid != null) {
//       firestoreUser.bindStream(streamFirestoreUser()!);
//       //await isAdmin();
//     }
//     if (user == null) {
//       Get.offAll(() => Start());
//     } else {
//       Get.offAll(() => HomePage());
//     }
//   }

//   //Streams the firestore user from the firestore collection
//   Stream<UserModel> streamFirestoreUser() {
//     print('streamFirestoreUser()');

//     return _db
//         .doc('/users/${firebaseUser.value!.uid}')
//         .snapshots()
//         .map((snapshot) => UserModel.fromMap(snapshot.data()!));
//   }

//   void signIn() async {
//     showLoading();
//     try {
//       await auth
//           .signInWithEmailAndPassword(
//               email: email.text.trim(), password: password.text.trim())
//           .then((result) {
//         // String _userId = result.user.uid;
//         // _initializeUserModel(_userId);
//         _clearControllers();
//       });
//     } catch (e) {
//       debugPrint(e.toString());
//       Get.snackbar("Sign In failed", "Try again");
//     }
//   }

//   void signUp() async {
//     showLoading();
//     try {
//       await auth
//           .createUserWithEmailAndPassword(
//               email: email.text.trim(), password: password.text.trim())
//           .then((result) {
//         // String _userId = result.user.uid;
//         // _addUserToFirestore(_userId);
//         _clearControllers();
//       });
//     } catch (e) {
//       debugPrint(e.toString());
//       Get.snackbar("Sign In failed", "Try again");
//     }
//   }

//   void signOut() async {
//     auth.signOut();
//   }

//   _addUserToFirestore(String userId) {
//     firebaseFirestore.collection(userCollection).doc(userId).set(
//         {"name": name.text.trim(), "id": userId, "email": email.text.trim()});
//   }

//   // _initializeUserModel(String userId) async {
//   //   userModel.value = await firebaseFirestore
//   //       .collection(userCollection)
//   //       .doc(userId)
//   //       .get()
//   //       .then((doc) => UserModel.fromSnapshot(doc));
//   // }

//   _clearControllers() {
//     name.clear();
//     email.clear();
//     password.clear();
//   }
// }

// showLoading() {
//   Get.defaultDialog(
//       title: "Loading...",
//       content: CircularProgressIndicator(),
//       barrierDismissible: false);
// }

// dismissLoadingWidget() {
//   Get.back();
// }
