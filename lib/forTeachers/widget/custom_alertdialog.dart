import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatefulWidget {
  final String from;
  const CustomAlertDialog({Key? key, required this.from}) : super(key: key);

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {

  CollectionReference room = FirebaseFirestore.instance.collection('chatRoom');
  //send Contact
  void sendContact(
      String contactName, String id, String who
      ) {
    // type: 0 = text, 1 = image, 2 = sticker
    var documentReference = FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(widget.from + '-' + "tPt4OQ2RwVbZmnFdhIi4MvrDQnC3")
        .collection('messages')
        .doc();

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        {
          'authorId': "tPt4OQ2RwVbZmnFdhIi4MvrDQnC3", // Akim
          'createdAt': DateTime.now(), //hello
          'contactName': contactName,
          'id': id,
          'type': "contact",
          'new': true,
          'who': who,
        },
      );
    });
  }
  //inform that you send contact
  Future<void> addInformAboutContact() {
    // Call the user's CollectionReference to add a new user
    return room.doc(widget.from + '-' + "tPt4OQ2RwVbZmnFdhIi4MvrDQnC3")
        .set({
      'time': DateTime.now(),
      'message': 'новый контакт',
    },SetOptions(merge: true),);
  }


  String _contactid = '';
  String _contactname = '';
  String dropdownValue = 'student';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Отправка изображения'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Имя контакта'
              ),
              onChanged: (val) {
                setState(() {
                  _contactname = val;
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Скопируй айди долгим нажатием'
              ),
              onChanged: (val) {
                setState(() {
                  _contactid = val;
                });
              },
            ),
            DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: <String>['student', 'teacher',]
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const Text('Отправить контакт?'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Нет'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Да'),
          onPressed: () {
            addInformAboutContact();
            sendContact(_contactname, _contactid, dropdownValue);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
