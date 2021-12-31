import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kkenglish/core/style.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kkenglish/forTeachers/widget/custom_alertdialog.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kkenglish/kamila/widget/firebase_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatNavBar extends StatefulWidget {
  final String from;
  final String to;
  final String myId;
  const ChatNavBar({Key? key, required this.from, required this.to, required this.myId}) : super(key: key);

  @override
  _ChatNavBarState createState() => _ChatNavBarState();
}

class _ChatNavBarState extends State<ChatNavBar> {

  //Pick image

  String _imageUrl1 = '';

  File? image1;

  UploadTask? task1;

  //Pick image
  Future pickImage1(String from, String to) async{
    final image = await ImagePicker().pickImage(
        maxHeight: 480,
        maxWidth: 640,
        imageQuality: 50,
        source: ImageSource.gallery);
    if (image == null) return;

    final imageTemporary = File(image.path);
    setState(() {
      image1 = imageTemporary;
      uploadImage1(from, to);
    });
    void sendFile() {
      // type: 0 = text, 1 = image, 2 = sticker
      var documentReference = FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(widget.from + '-' + widget.to)
          .collection('messages')
          .doc("123456");

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'idTo': widget.myId == widget.to ? widget.from : widget.to,
            'authorId': widget.myId, // Akim
            'createdAt': DateTime.now(),
            'imageUrl': '',
            'type': "image",
            'new': true,
          },
        );
      });
    }
    sendFile();
  }

  //Upload image
  Future uploadImage1(String from, String to) async {
    if (image1 == null) return;

    // final imageName = basename(image1!.path);
    // final destination = '$from-$to/$imageName';

    task1 = FirebaseImage.uploadFile('images', image1!);
    setState(() {
    });

    if(task1 == null) return;

    final snapshot = await task1!.whenComplete(() {
    });
    final urlDownload = await snapshot.ref.getDownloadURL();
    setState(() {
      _imageUrl1 = urlDownload;
    });
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    final _controller = TextEditingController();

    void sendMessage() async {
      FocusScope.of(context).unfocus();
      _controller.clear();
    }

    //send Message
    void onSendMessageToMe(
        String message
        ) {
      // type: 0 = text, 1 = image, 2 = sticker
      var documentReference = FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(widget.from + '-' + widget.to)
          .collection('messages')
          .doc();

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'idTo': widget.myId == widget.to ? widget.from : widget.to,
            'authorId': widget.myId, // Akim
            'createdAt': DateTime.now(), //hello
            'text': message,
            'image': '',
            'type': "text",
            'new': true,
          },
        );
      });
      Future.delayed(const Duration(milliseconds: 1000), () {
        message = '';
      });
    }
    CollectionReference room = FirebaseFirestore.instance.collection('chatRoom');
    //inform that you send message
    Future<void> addUser(message) {
      // Call the user's CollectionReference to add a new user
      return room.doc(widget.from + '-' + widget.to)
          .set({
        'time': DateTime.now(),
        'message': message,
      },SetOptions(merge: true),);
    }

    String _message = '';

    //send Image
    void sendImage() {
      // type: 0 = text, 1 = image, 2 = sticker
      var documentReference = FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(widget.from + '-' + widget.to)
          .collection('messages')
          .doc();

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'idTo': widget.myId == widget.to ? widget.from : widget.to,
            'authorId': widget.myId, // Akim
            'createdAt': DateTime.now(),
            'imageUrl': _imageUrl1,
            'type': "image",
            'new': true,
          },
        );
      });
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          _imageUrl1 = '';
        });
      });
    }


    //inform that you send message
    Future<void> addImage() {
      // Call the user's CollectionReference to add a new user
      return room.doc(widget.from + '-' + widget.to)
          .set({
        'time': DateTime.now(),
        'message': "новая картнка получена",
      },SetOptions(merge: true),);
    }

    void deleteImageLoading() {
      // type: 0 = text, 1 = image, 2 = sticker
      FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(widget.from + '-' + widget.to)
          .collection('messages')
          .doc('123456').delete();
    }

    if(_imageUrl1 != ''){
      sendImage();
      addImage();
      deleteImageLoading();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 10,
              ),
              Container(
                height: size.height*0.07,
                width: size.width*0.94,
                decoration: BoxDecoration(
                  color: AppColors.main,
                  borderRadius:  BorderRadius.circular(32),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
                        pickImage1(widget.from, widget.to);
                        // showDialog<void>(
                        //     context: context,
                        //     barrierDismissible: false, // user must tap button!
                        //     builder: (BuildContext context) {
                        //       return CustomAlertDialog(from: widget.from,);
                        //     });
                      },
                      child: Container(
                        height: size.height*0.07,
                        width: size.width*0.1,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.main,
                        ),
                        child: const Icon(Icons.image, color: Colors.white, size: 20,),
                      ),
                    ),
                    SizedBox(
                      height: size.height*0.07,
                      width: size.width*0.7,
                      child: TextField(
                          controller: _controller,
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: 2,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintStyle: AppColors.style18wb,
                            hintText: 'Сообщение...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 20, right: 20),
                          ),
                          onChanged: (value) => _message = value
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        if(_message != ''){
                          addUser(_message);
                          onSendMessageToMe(_message);
                          sendMessage();
                          setState(() {
                            _imageUrl1 = '';
                          });
                        }
                      },
                      child: Container(
                        height: size.height*0.07,
                        width: size.width*0.1,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.main,
                        ),
                        child: const Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 30,),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
  }

  // Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
  //   stream: task.snapshotEvents,
  //   builder: (context, snapshot) {
  //     if (snapshot.hasData) {
  //       final snap = snapshot.data!;
  //       final progress = snap.bytesTransferred / snap.totalBytes;
  //       // final percentage = (progress * 100).toStringAsFixed(1);
  //       if(progress == 1){addImage();sendImage();}
  //       return LinearProgressIndicator(
  //         value: progress,
  //       );
  //       //   Center(
  //       //   child: percentage != "100.0" ? Text(
  //       //     '$percentage %',
  //       //     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
  //       //   ) : Icon(Icons.check, color: AppColors.main, size: 30,),
  //       // );
  //     } else {
  //       return Container();
  //     }
  //   },
  // );
}