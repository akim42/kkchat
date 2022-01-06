// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:kkenglish/chat/messages.dart';
// import 'package:kkenglish/core/style.dart';
// import 'package:kkenglish/forTeachers/main_screen.dart';
// import 'package:kkenglish/main.dart';
//
// class ChatRooms extends StatefulWidget {
//   final String from;
//   final String to;
//   final String message;
//   final String userImage;
//   final String userID;
//   const ChatRooms({Key? key, required this.from,required this.to, required this.message, required this.userImage, required this.userID}) : super(key: key);
//
//   @override
//   _WriteMessageState createState() => _WriteMessageState();
// }
//
// class _WriteMessageState extends State<ChatRooms> {
//   final _controller = TextEditingController();
//   String message = '';
//
//   void sendMessage() async {
//     FocusScope.of(context).unfocus();
//     _controller.clear();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     void onSendMessageToMe(
//         // String message, int type
//         ) {
//       // type: 0 = text, 1 = image, 2 = sticker
//       var documentReference = FirebaseFirestore.instance
//           .collection('chatRoom')
//           .doc(widget.from + '-' + widget.to)
//           .collection('messages')
//           .doc();
//
//       FirebaseFirestore.instance.runTransaction((transaction) async {
//           transaction.set(
//           documentReference,
//           {
//             'authorId': widget.from, // Akim
//             'createdAt': DateTime.now(), //hello
//             'text': message,
//             'image': widget.userImage,
//             'type': "text"
//           },
//         );
//       });
//       Future.delayed(const Duration(milliseconds: 1000), () {
//         message = '';
//       });
//     }
//     CollectionReference room = FirebaseFirestore.instance.collection('chatRoom');
//
//     Future<void> addUser() {
//       // Call the user's CollectionReference to add a new user
//       return room.doc(widget.from + '-' + widget.to)
//           .set({
//         'time': DateTime.now(),
//         'message': message,
//       },SetOptions(merge: true),);
//     }
//
//
//     final Size size = MediaQuery.of(context).size;
//     return Scaffold(
//         backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
//         body:
//         Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 10, top: 30, bottom: 10),
//                   child: SizedBox(
//                     height: 40,
//                     width: 40,
//                     child: GestureDetector(
//                         onTap: () {
//                           Navigator.of(context).pushReplacement(MaterialPageRoute(
//                               builder: (BuildContext context) {
//                                 return NotForKamila();
//                               })
//                           );
//                         },
//                         child: Icon(Icons.arrow_back_ios_rounded, color: AppColors.greyDark,size: 30,)
//                     ),
//                   ),
//                 ),
//                 const Padding(
//                     padding: EdgeInsets.only(left: 10, right: 10, top: 30, bottom: 10),
//                     child: Text('Профиль', style: TextStyle(fontSize: 17, color: Colors.black, fontWeight: FontWeight.w600),)
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.only(right: 10, top: 30, bottom: 10),
//                   child: SizedBox(
//                     height: 40,
//                     width: 40,
//                   ),
//                 ),
//               ],
//             ),
//             Expanded(
//                 child: MessagesWidget(senderName: widget.room['senderName'],from: widget.userID, to: widget.to, myId: widget.from, myName: 'name',)
//             ),
//             Padding(
//               padding: const EdgeInsets.only(bottom: 10.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Container(
//                             height: size.height*0.07,
//                             width: size.width*0.94,
//                             decoration: BoxDecoration(
//                               color: AppColors.greyLight,
//                               borderRadius:  BorderRadius.circular(32),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 SizedBox(
//                                   height: size.height*0.07,
//                                   width: size.width*0.8,
//                                   child: TextField(
//                                         controller: _controller,
//                                         textCapitalization: TextCapitalization.sentences,
//                                         autocorrect: true,
//                                         enableSuggestions: true,
//                                         decoration: const InputDecoration(
//                                           hintStyle: TextStyle(fontSize: 17),
//                                           hintText: 'Сообщение...',
//                                           suffixIcon: Icon(Icons.create_rounded),
//                                           border: InputBorder.none,
//                                           contentPadding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
//                                         ),
//                                         onChanged: (value) => message = value
//                                   ),
//                                 ),
//                                 GestureDetector(
//                                   onTap: (){
//                                     if(message != ''){
//                                       addUser();
//                                       onSendMessageToMe();
//                                       sendMessage();
//                                     }
//                                   },
//                                   child: Container(
//                                     height: size.height*0.07,
//                                     width: size.width*0.1,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: AppColors.greyLight,
//                                     ),
//                                     child: const Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 30,),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                     ),
//                     const SizedBox(width: 10),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//     );
//   }
// }
