import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kkenglish/chat/messages.dart';
import 'package:kkenglish/kamila/widget/chat_navbar.dart';
import 'package:kkenglish/kamila/widget/navbar_name_delete_save.dart';
import 'dart:ui';


class KamilaChatRooms extends StatefulWidget {
  final room;
  const KamilaChatRooms({Key? key, required this.room}) : super(key: key);

  @override
  _WriteMessageState createState() => _WriteMessageState();
}

class _WriteMessageState extends State<KamilaChatRooms> {

  @override
  Widget build(BuildContext context) {
    String _senderName = widget.room['senderName'];
    String _from = widget.room['from'];

    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body:
      Column(
        children: [
          //
          NavbarDeleteSave(senderName: _senderName,),

          Expanded(child: MessagesWidget(from: _from, to: "ysc47YoKUifJXCW3Kwq44hHrOm93", myId: 'ysc47YoKUifJXCW3Kwq44hHrOm93', myName: 'Kamila',)),
          //Chat

          ChatNavBar(from: _from, to: widget.room['to'],),
        ],
      ),
    );
  }
}

