import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kkenglish/auth/singup.dart';
import 'package:kkenglish/chat/chatscreen.dart';
import 'package:intl/intl.dart';
import 'package:kkenglish/core/style.dart';
import 'package:kkenglish/forTeachers/main_screen.dart';
import 'package:kkenglish/main.dart';


class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LogIn> {

  late bool isLoggedIn = false;

  bool change = true;


  // void _loadUserData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _userNamePref = (prefs.getString("userName") ?? '');
  //     _userEmailPref = (prefs.getString("email") ?? '');
  //     _userPasswordPref = (prefs.getString("desc") ?? '');
  //     _userLogInPref = (prefs.getString("LogIn") ?? '');
  //   });
  // }

  // List<Chats> exist = [];
  // var seen = Set<String>();
  // List<Chats> uniquelist = [];

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  String errorMessage = '';
  bool isLoading = false;
  bool secure = false;
  bool singUp = true;
  bool loadingState = false;


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
    final Size size = MediaQuery.of(context).size;
    return
      Scaffold(
          backgroundColor: AppColors.bg,
          body: Form(
              child: Scrollbar(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
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
                            Text('Если у вас уже есть аккаунт,', style: AppColors.style16bb,),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('введите его', style: AppColors.style16bb,),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
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
                            // validator: validateEmail,
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
                            // validator: validatePassword,
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
                                  secure = !secure;
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
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(
                            child:
                            loadingState == true? const Center(child: CircularProgressIndicator(),)
                                : Text(errorMessage, style: const TextStyle(color: Colors.red)),
                          ),
                        ),
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
                                      .signInWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                } on FirebaseAuthException catch (error) {
                                  setState(() {
                                    loadingState = true;
                                  });
                                  errorMessage = error.message!;
                                }
                                setState(() {
                                  loadingState = false;
                                });
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return NotForKamila();
                                    })
                                );
                              },
                              child: const Text(
                                "Войти",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return SingUP();
                                })
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Если у Вас еще нет аккаунта,', style: AppColors.style16bb,),
                                Text('зарегистрируйтесь', style: AppColors.style16bunder,),
                              ],
                            ),
                          ),
                        ),
                      ]),
                ),
              ))
      );
  }
}


