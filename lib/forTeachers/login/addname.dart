import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kkenglish/core/style.dart';
import 'package:kkenglish/forTeachers/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddName extends StatefulWidget {
  String email;
  String password;
  AddName({Key? key, required this.email, required this.password}) : super(key: key);

  @override
  _AuthAppState createState() => _AuthAppState();
}

class _AuthAppState extends State<AddName> {
  final nameController = TextEditingController();

  CollectionReference room = FirebaseFirestore.instance.collection('chatRoom');

  Future<void> sendMessageToKamila(senderID, senderName) {
    // Call the user's CollectionReference to add a new user
    return room.doc("${FirebaseAuth.instance.currentUser!.uid}-ysc47YoKUifJXCW3Kwq44hHrOm93")
        .set({
      'senderImage': '',
      'name': "Kamila Admin",
      'senderName': senderName,
      'userIds': FieldValue.arrayUnion([senderID, "ysc47YoKUifJXCW3Kwq44hHrOm93"]),
      'docImage': "Kamila",
      'time': DateTime.now(),
      'message': 'I have to login',
      'to': "ysc47YoKUifJXCW3Kwq44hHrOm93",
      'from': senderID,
      'pass': 1,
    },SetOptions(merge: true),);
  }

  bool loadingState = false;

  late String _userNamePref = '';
  late String _userIDPref = '';



  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userNamePref = (prefs.getString("userName") ?? '');
      _userIDPref = (prefs.getString("userID") ?? '');
    });
  }

  void _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('password', widget.password);
      prefs.setString('email', widget.email);
      prefs.setString("userID", _userIDPref);
      prefs.setString("userName", _userNamePref);
    });
  }

  @override
  void initState() {
// TODO: implement initState
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    _userIDPref = FirebaseAuth.instance.currentUser!.uid;
    print(FirebaseAuth.instance.currentUser!.uid);
    final Size size = MediaQuery.of(context).size;
    return
      Scaffold(
          backgroundColor: AppColors.bg,
          body: Padding(
              padding: const EdgeInsets.all(20.0),
              child:
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('И последний вопрос ✈', style: AppColors.style20bb,),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Как вас зовут ?', style: AppColors.style16bb,),
                        ],
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
                        controller: nameController,
                        validator: validateEmail,
                        cursorColor: const Color(0x808257E5),
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.person,
                            color: AppColors.main,
                          ),
                          hintText: "Имя",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 15),
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
                            const snackBar = SnackBar(
                              content: Text('Нужно ввести имя'),
                            );
                            if(nameController.text == ''){
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                            else{
                              _userNamePref = nameController.text;
                              sendMessageToKamila(_userIDPref, nameController.text);
                              _saveData();
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return NotForKamila();
                                })
                              );
                            }
                          },
                          child: const Text(
                            "Войти",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),]))
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