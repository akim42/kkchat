import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kkenglish/chat/messages.dart';
import 'package:kkenglish/core/style.dart';
import 'package:kkenglish/kamila/widget/chat_navbar.dart';
import 'package:kkenglish/kamila/widget/custom_alertdialog.dart';
import 'package:kkenglish/main.dart';
import 'package:flutter/services.dart';

class WatchDogMode extends StatefulWidget {
  final room;
  const WatchDogMode({Key? key, required this.room}) : super(key: key);

  @override
  _WriteMessageState createState() => _WriteMessageState();
}

class _WriteMessageState extends State<WatchDogMode> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body:
      Column(
        children: [
          //Profile menu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 30, bottom: 10),
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios_rounded, color: AppColors.greyDark,size: 30,)
                  ),
                ),
              ),
              const Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 10),
                  child: Text('Профиль', style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.w600),)
              ),
              const Padding(
                padding: EdgeInsets.only(right: 10, top: 30, bottom: 10),
                child: SizedBox(
                  height: 40,
                  width: 40,
                ),
              ),
            ],
          ),
          Expanded(
              child: MessagesWidget(from: widget.room['from'], to: widget.room['to'], myId:  'ysc47YoKUifJXCW3Kwq44hHrOm93', myName: 'Kamila',)
          ),
          // ChatNavBar(from: widget.room['from'],)
        ],
      ),
    );
  }
}
