import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LinkDialog extends StatefulWidget {
  final String from;
  const LinkDialog({Key? key, required this.from}) : super(key: key);

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<LinkDialog> {

  CollectionReference room = FirebaseFirestore.instance.collection('chatRoom');
  //send Contact
  void sendContact(String id) {
    // type: 0 = text, 1 = image, 2 = sticker
    var documentReference = FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(widget.from + '-' + "ysc47YoKUifJXCW3Kwq44hHrOm93")
        .collection('messages')
        .doc();

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        {
          'authorId': "ysc47YoKUifJXCW3Kwq44hHrOm93", // Akim
          'createdAt': DateTime.now(),
          'link': id,
          'type': "link",
          'new': true,
        },
      );
    });
  }
  //inform that you send contact
  Future<void> addInformAboutContact() {
    // Call the user's CollectionReference to add a new user
    return room.doc(widget.from + '-' + "ysc47YoKUifJXCW3Kwq44hHrOm93")
        .set({
      'time': DateTime.now(),
      'message': 'Ссылка на файл',
    },SetOptions(merge: true),);
  }


  String _contactid = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Отправить ссылку на фаил'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'пример: https://fly.kg/best.jpg'
              ),
              onChanged: (val) {
                setState(() {
                  _contactid = val;
                });
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Отмена'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Отправить'),
          onPressed: () {
            addInformAboutContact();
            sendContact(_contactid);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
