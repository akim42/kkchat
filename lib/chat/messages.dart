import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:kkenglish/config.dart';
import 'package:kkenglish/core/style.dart';
import 'package:intl/intl.dart';
import 'package:kkenglish/kamila/widget/image_pinch_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


class MessagesWidget extends StatefulWidget {
  final String from;
  final String to;
  final String myId;
  final String myName;

  const MessagesWidget({
    required this.from,
    required this.to,
    required this.myId,
    required this.myName,
    Key? key,
  }) : super(key: key);

  @override
  State<MessagesWidget> createState() => _MessagesWidgetState();
}

class _MessagesWidgetState extends State<MessagesWidget> {

  List<Messages> exist = [];
  var seen = Set<String>();
  List<Messages> uniquelist = [];
  var seenTime = Set<String>();

  List<String> existTime = [];




  UploadTask? task1;
  bool image1bool = false;
  File? image1;

  //sendMessageToTeacher
  void sendMessageToTeacher(String TeacherID, String teacherName) {
    // type: 0 = text, 1 = image, 2 = sticker
    var documentReference = FirebaseFirestore.instance
        .collection('chatRoom')
        .doc(widget.from + '-' + TeacherID)
        .collection('messages')
        .doc();

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        {
          'authorId': widget.myId, // Akim
          'createdAt': DateTime.now(), //hello
          'text': 'Hi i am your new student',
          'image': '',
          'type': "text",
          'new': true,
        },
      );
    });
  }
  CollectionReference room = FirebaseFirestore.instance.collection('chatRoom');
  //inform that you send message
  Future<void> addRoom(String TeacherID, String teacherName) {
    // Call the user's CollectionReference to add a new user
    return room.doc(widget.from + '-' + TeacherID)
        .set({
      'time': DateTime.now(),
      'message': 'Hi i am your new student',
      'docImage': '',
      'from':  widget.myId,
      'senderImage': '',
      'name': teacherName,
      'senderName': widget.myName,
      'to': TeacherID,
      "userIds": [widget.from, TeacherID],
    },SetOptions(merge: true),);
  }


  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   WidgetsBinding.instance.addObserver(this);
  // }

  Future deleteMessage (String docIndex) async{
      // type: 0 = text, 1 = image, 2 = sticker
      FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(widget.from + '-' + widget.to)
          .collection('messages')
          .doc(docIndex).delete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentState.addListener(() {
      setState(() {
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chatRoom').doc('${widget.from}-${widget.to}').collection("messages").orderBy('createdAt', descending: true).limit(100).snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              final messages = snapshot.data!.docs;
              return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];

                    return
                          Column(
                            children: [
                              //date time

                              DateFormat.MMMMd().format(message['createdAt'].toDate()).toString() == DateFormat.MMMMd().format(DateTime.now()).toString()
                                    ?
                                  Container()
                                      :
                                Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                                  Text(DateFormat.MMMMd().format(message['createdAt'].toDate()).toString()),
                                ],),

                              Row(
                                mainAxisAlignment: message['authorId'] == widget.myId
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: <Widget>[
                                  // message['to'].toString() == from.toString() || message['to'].toString() == to.toString() ?

                                  //My message
                                  message['authorId'] == widget.myId ?
                                  GestureDetector(
                                    //LOng press
                                    onLongPress: (){
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: Center(child: const Text('Удалить ?')),
                                            actions: <Widget>[
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  TextButton(
                                                    child: const Text('Нет'),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text('Да'),
                                                    onPressed: () {
                                                      deleteMessage(message.id);
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                      );
                                    },
                                    child: Container(
                                        padding: message['type'] != 'image' ? const EdgeInsets.all(20) : const EdgeInsets.all(0),
                                        margin: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 0),
                                        constraints: BoxConstraints(maxWidth: size.width*0.8),
                                        decoration: BoxDecoration(
                                          color: AppColors.main,
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            bottomLeft: Radius.circular(20),
                                            topLeft: Radius.circular(20),
                                          ),
                                        ),
                                        child:
                                        //Contact type of message
                                        message['type'] == 'contact' ?
                                            //Contact type
                                        GestureDetector(
                                          child: message['authorId'] == widget.myId ?
                                           Column(
                                            children: [
                                              Text('Контакт', style: GoogleFonts.openSans(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w600)),
                                              Text(message['contactName'].toString(), style: GoogleFonts.openSans(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600)),
                                              Text(message['id'].toString(), style: GoogleFonts.openSans(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w600))
                                            ],
                                          ) : Column(
                                            children: [
                                              Text('Контакт', style: GoogleFonts.openSans(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
                                              Text(message['contactName'].toString(), style: GoogleFonts.openSans(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600)),
                                              Text(message['id'].toString(), style: GoogleFonts.openSans(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600))
                                            ],
                                          ),
                                        )
                                            :
                                        message['type'] == 'image' ?
                                        GestureDetector(
                                            //on tap
                                            onTap: (){
                                              if(message['type'] == 'image'){
                                                Navigator.of(context).push(MaterialPageRoute(
                                                    builder: (BuildContext context) {
                                                      return ImageViewer(image: message['imageUrl'],);
                                                    })
                                                );
                                              }
                                            },
                                            child:
                                          ClipRRect(
                                              borderRadius: const BorderRadius.only(
                                                topRight: Radius.circular(20),
                                                bottomLeft: Radius.circular(20),
                                                topLeft: Radius.circular(20),
                                              ),
                                              child:
                                              message['imageUrl'] != '' ?
                                              CachedNetworkImage(
                                                imageUrl: message['imageUrl'],
                                              ) :
                                              Container(
                                                height: 150,
                                                  width: 150,
                                                  child: Center(
                                                      child: Container(
                                                        height: 30,
                                                          width: 30,
                                                          child: const CircularProgressIndicator(
                                                            color: Colors.white,
                                                          ))))
                                          )
                                        )
                                            :
                                        message['type'] == 'link' ?
                                        GestureDetector(
                                          onTap: () async {
                                            if (!await launch(message['link'])) throw 'Could not launch ${message['link']}';
                                            },
                                          child: Column(
                                            children: [
                                              Text('Ссылка', style: GoogleFonts.openSans(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
                                              Text(message['link'], style: GoogleFonts.openSans(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600)),
                                            ],
                                          ),
                                        )
                                            :
                                        Text(message['text'].toString(), style: GoogleFonts.openSans(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600))
                                    ),
                                  ) :


                                  //other message
                                  GestureDetector(
                                    //LOng press
                                    onLongPress: (){
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: Center(child: const Text('Удалить ?')),
                                          actions: <Widget>[
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                TextButton(
                                                  child: const Text('Нет'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text('Да'),
                                                  onPressed: () {
                                                    deleteMessage(message.id);
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    onTap: message['type'] == 'contact' ? () async {
                                      await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          content: const Text('Создать переписку с данным контактом?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context, rootNavigator: true).pop(); // dismisses only the dialog and returns nothing
                                              },
                                              child: const Text('Нет'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                sendMessageToTeacher(message['id'], message['contactName']);
                                                addRoom(message['id'], message['contactName']);
                                                Navigator.of(context, rootNavigator: true).pop(); // dismisses only the dialog and returns nothing
                                              },
                                              child: const Text('Да'),
                                            ),
                                          ],
                                        ),
                                      );
                                    } : () {},
                                    child: Container(
                                      padding: message['type'] != 'image' ? const EdgeInsets.all(20) : const EdgeInsets.all(0),
                                      margin: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 0),
                                      constraints: BoxConstraints(maxWidth: size.width*0.8),
                                      decoration: const BoxDecoration(
                                        color: Color.fromRGBO(247, 247, 248, 1),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                          topLeft: Radius.circular(20),
                                        ),
                                      ),
                                      child:
                                      message['type'] == 'contact' ?
                                      //Contact type
                                      Column(
                                        children: [
                                          Text('Контакт', style: GoogleFonts.openSans(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
                                          Text(message['contactName'].toString(), style: GoogleFonts.openSans(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600)),
                                          Text(message['id'].toString(), style: GoogleFonts.openSans(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600))
                                        ],
                                      )
                                          :
                                      message['type'] == 'image' ?
                                      GestureDetector(
                                          //Alert dialog Room with user is created
                                        //on tap
                                          onTap: (){
                                            if(message['type'] == 'image'){
                                              Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (BuildContext context) {
                                                    return ImageViewer(image: message['imageUrl'],);
                                                  })
                                              );
                                            }
                                          },
                                          child:
                                          ClipRRect(
                                              borderRadius: const BorderRadius.only(
                                                topRight: Radius.circular(20),
                                                bottomLeft: Radius.circular(20),
                                                topLeft: Radius.circular(20),
                                              ),
                                              child:
                                              CachedNetworkImage(
                                                imageUrl: message['imageUrl'],
                                              ),
                                          )
                                      )
                                          :
                                      message['type'] == 'link' ?
                                      GestureDetector(
                                        onTap: () async {
                                          if (!await launch(message['link'])) throw 'Could not launch ${message['link']}';
                                        },
                                        child: Column(
                                          children: [
                                            Text('Ссылка', style: GoogleFonts.openSans(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
                                            Text(message['link'], style: GoogleFonts.openSans(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w600)),
                                          ],
                                        ),
                                      ):
                                      Text(message['text'].toString(), style: AppColors.comfort15bw600,),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: message['authorId'] == widget.myId
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5),
                                    child: Text(DateFormat.Hm().format(message['createdAt'].toDate()).toString()),
                                  ),
                                ],
                              ),
                            ],
                      );
                  });
          }
        });}

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
    stream: task.snapshotEvents,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final snap = snapshot.data!;
        final progress = snap.bytesTransferred / snap.totalBytes;
        final percentage = (progress * 100).toStringAsFixed(1);

        return Center(
          child: percentage != "100.0" ? Text(
            '$percentage %',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ) : Icon(Icons.check, color: AppColors.main, size: 30,),
        );
      } else {
        return Container();
      }
    },
  );
}

class Messages {
  Timestamp createdAt;
  String dateTime;

  // List<dynamic> userIds;

  Messages({
    required this.createdAt,
    required this.dateTime,
  });
}
