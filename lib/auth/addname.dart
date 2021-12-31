import 'package:kkenglish/core/style.dart';
import 'package:kkenglish/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddName extends StatefulWidget {
  AddName({Key? key}) : super(key: key);

  @override
  _AuthAppState createState() => _AuthAppState();
}

class _AuthAppState extends State<AddName> {
  final nameController = TextEditingController();

  String _userNamePref = '';

  void _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString("userName", _userNamePref);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                          onPressed: (){},
                          // onPressed: () async {
                          //   _userNamePref == '' ? {}
                          //   : Navigator.of(context).pushReplacement(MaterialPageRoute(
                          //       builder: (BuildContext context) {
                          //         return MyHomePage();
                          //       })
                          //   );
                          //   _saveData();
                          // },
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