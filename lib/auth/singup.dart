import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kkenglish/auth/addName.dart';
import 'package:kkenglish/auth/login.dart';
import 'package:kkenglish/auth/singup.dart';
import 'package:kkenglish/core/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../main.dart';

class SingUP extends StatefulWidget {
  SingUP({Key? key}) : super(key: key);

  @override
  _AuthAppState createState() => _AuthAppState();
}

class _AuthAppState extends State<SingUP> {
  late TextEditingController emailPrefController;
  late TextEditingController passwordPrefController;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  String errorMessage = '';
  bool isLoading = false;
  bool secure = false;

  @override
  void initState() {
// TODO: implement initState
    super.initState();
    _loadUserData();
    emailPrefController = TextEditingController(text: _userEmailPref);
    passwordPrefController = TextEditingController(text: _userPasswordPref);
  }

  late String _userNamePref = '';
  late String _userIDPref = '';
  late String _userEmailPref = '';
  late String _userPasswordPref = '';

  bool loadingState = false;


  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userNamePref = (prefs.getString("userName") ?? '');
      _userEmailPref = (prefs.getString("email") ?? '');
      _userPasswordPref = (prefs.getString("password") ?? '');
      _userIDPref = (prefs.getString("userID") ?? '');
    });
  }

  void _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('password', _userPasswordPref);
      prefs.setString('email', _userEmailPref);
      prefs.setString("userID", _userIDPref);
      prefs.setString("userName", _userNamePref);
    });
  }

  bool userState = false;
  String userID = '';

  CollectionReference room = FirebaseFirestore.instance.collection('chatRoom');

  Future<void> sendMessageToKamila(senderID) {
    // Call the user's CollectionReference to add a new user
    return room.doc("${senderID + '-' + "ysc47YoKUifJXCW3Kwq44hHrOm93"}")
        .set({
      'senderImage': '',
      'name': "Kamila Admin", // Stokes and Sons
      'userIds': FieldValue.arrayUnion([senderID, "ysc47YoKUifJXCW3Kwq44hHrOm93"]),
      'docImage': "Kamila",
      'time': DateTime.now(),
      'message': '',
      'to': "ysc47YoKUifJXCW3Kwq44hHrOm93",
      'from': senderID,
      'pass': 1,
    },SetOptions(merge: true),);
  }


  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> _notifier = ValueNotifier(false);
    final Size size = MediaQuery.of(context).size;
    return
      Scaffold(
          resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.bg,
        body: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child:
                  Form(
                      key: _key,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Добро пожаловать в чат 🙋', style: AppColors.style20bb,),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Чтобы зарегистрироваться,', style: AppColors.style16bb,),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('введите ваши данные', style: AppColors.style16bb,),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              width: size.width * 0.6,
                              decoration: BoxDecoration(
                                color: const Color(0x1A8257E5),
                                borderRadius: BorderRadius.circular(29),
                              ),
                              child: TextFormField(
                                controller: emailController,
                                validator: validateEmail,
                                cursorColor: const Color(0x808257E5),
                                decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.person,
                                    color: AppColors.main,
                                  ),
                                  hintText: "Email",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              width: size.width * 0.6,
                              decoration: BoxDecoration(
                                color: const Color(0x1A8257E5),
                                borderRadius: BorderRadius.circular(29),
                              ),
                              child: TextFormField(
                                controller: passwordController,
                                validator: validatePassword,
                                obscureText: secure,
                                cursorColor: const Color(0x808257E5),
                                decoration: InputDecoration(
                                  hintText: "Пароль",
                                  icon: Icon(
                                    Icons.lock,
                                    color: AppColors.main,
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        secure = !secure;
                                      });
                                    },
                                    child: secure ? Icon(
                                      Icons.visibility_off,
                                      color: AppColors.main,
                                    ) : Icon(
                                      Icons.visibility,
                                      color: AppColors.main,
                                    ),
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            ValueListenableBuilder(
                                valueListenable: _notifier,
                                builder: (context, bool quoteReady, child) {

                                  return quoteReady ? Center(child: Text(_notifier.value.toString()))
                                      : Center(child: Text(_notifier.value.toString()));
                                }),
                            // Padding(
                            //   padding: const EdgeInsets.all(12.0),
                            //   child: Center(
                            //     child:
                            //     loadingState == true ? const CircularProgressIndicator()
                            //         : Text(errorMessage, style: const TextStyle(color: Colors.red)),
                            //   ),
                            // ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              width: size.width * 0.6,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(29),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                                    primary: Colors.white,
                                    backgroundColor: AppColors.main,
                                  ),
                                  onPressed: () async {
                                    try {
                                      await FirebaseAuth.instance
                                          .createUserWithEmailAndPassword(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );
                                    } on FirebaseAuthException catch (error) {
                                      setState(() {
                                        loadingState = true;
                                      });
                                      errorMessage = error.message!;
                                    }
                                    _notifier.value = !_notifier.value;
                                    // setState(() {
                                    //   loadingState = false;
                                    // });
                                    // sendMessageToKamila(FirebaseAuth.instance.currentUser!.uid);
                                    // Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    //     builder: (BuildContext context) {
                                    //       return MyHomePage();
                                    //     })
                                    // );
                                  },
                                  child: const Text(
                                    "Зарегистрироваться",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return LogIn();
                                    })
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Если у Вас уже есть аккаунт', style: AppColors.style16bb,),
                                    Text('авторизируйтесь', style: AppColors.style16bunder,),
                                  ],
                                ),
                              ),
                            ),
                          ]))),
      );
  }
}

String? validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty) {
    return 'E-mail address is required.'; }
  String pattern = r'\w+@\w+\.\w+';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formEmail)) {
    return 'Invalid E-mail Address format.';
  }
  return null;
}

String? validatePassword(String? formPassword) {
  if (formPassword == null || formPassword.isEmpty) {
    return 'Password is required.';
  }
  String pattern =
      r'^(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formPassword)) {
    return '''
      Password must be at least 8 characters,
      include an uppercase letter, number and symbol.
      ''';
  }
  return null;
}