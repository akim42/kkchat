import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kkenglish/auth/login.dart';
import 'package:kkenglish/auth/singup.dart';
import 'package:intl/intl.dart';
import 'package:kkenglish/chat/chatscreen.dart';
import 'package:kkenglish/core/style.dart';
import 'package:kkenglish/kamila/all_chats.dart';
import 'package:kkenglish/kamila/chat_room_for_kamila.dart';
import 'package:kkenglish/notification/notification.dart';

//
//   late bool isLoggedIn = false;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     //_loadUserData();
//     super.initState();
//     // new Future.delayed(const Duration(seconds: 2));
//   }
//
//   // late String _userLogInPref = '';
//   // late String _userNamePref = '';
//   // late String _userIDPref = '';
//   // late String _userEmailPref = '';
//   // late String _userPasswordPref = '';
//
//   bool change = true;
//
//
//   // void _loadUserData() async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   setState(() {
//   //     _userNamePref = (prefs.getString("userName") ?? '');
//   //     _userEmailPref = (prefs.getString("email") ?? '');
//   //     _userPasswordPref = (prefs.getString("desc") ?? '');
//   //     _userLogInPref = (prefs.getString("LogIn") ?? '');
//   //   });
//   // }
//
//   // List<Chats> exist = [];
//   // var seen = Set<String>();
//   // List<Chats> uniquelist = [];
//
//
//   late TextEditingController emailPrefController;
//   late TextEditingController passwordPrefController;
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final GlobalKey<FormState> _key = GlobalKey<FormState>();
//
//   String errorMessage = '';
//   bool isLoading = false;
//   bool secure = false;
//   bool singUp = true;
//   bool loadingState = false;
//
//
//   QuerySnapshot<String, dynamic> = FirebaseFirestore.instance.collection('chatRoom').doc('${message['from']}-tPt4OQ2RwVbZmnFdhIi4MvrDQnC3').collection("messages").where('authorId', isNotEqualTo: "tPt4OQ2RwVbZmnFdhIi4MvrDQnC3").where('new', isEqualTo: true).snapshots();
//
//   Future<void> makePassZero(senderID) {
//     // Call the user's CollectionReference to add a new user
//     return room
//         .set({
//       'pass': 0,
//     },SetOptions(merge: true),);
//   }
//

class KamilaMainScreen extends StatefulWidget {
  const KamilaMainScreen({Key? key}) : super(key: key);

  @override
  _NewHomeState createState() => _NewHomeState();
}

class _NewHomeState extends State<KamilaMainScreen> {

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // final GoogleSignIn googleSignIn = GoogleSignIn();

  void registerNotification() {
    firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage: $message');
      if (message.notification != null) {
        showNotification(message.notification!);
      }
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('push token: $token');
      if (token != null) {
        FirebaseFirestore.instance
            .collection("users")
            .doc("ysc47YoKUifJXCW3Kwq44hHrOm93").set({'pushToken': token},SetOptions(merge: true),);
      }
    }).catchError((err) {
      print(err);
    });
  }

  void configLocalNotification() {
    AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();
    InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(RemoteNotification remoteNotification) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      Platform.isAndroid ? 'fly.kkenglish.kg.kkenglish' : 'fly.kkenglish.kg.kkenglish',
      'KKenglish',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    IOSNotificationDetails iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

    print(remoteNotification);

    await flutterLocalNotificationsPlugin.show(
      0,
      remoteNotification.title,
      remoteNotification.body,
      platformChannelSpecifics,
      payload: null,
    );
  }

  List<Rooms> exist = [];
  var seen = Set<String>();
  List<Rooms> uniquelist = [];
  // ChatRoom chatroom = ChatRoom();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    registerNotification();
    configLocalNotification();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   NotificationApi.init();
  //   listenNotifications();
  // }
  //
  // void listenNotifications() =>
  //     NotificationApi.onNotifications.stream.listen(onClickedNotification);
  //
  // void onClickedNotification(String? payload) =>
  //     Navigator.of(context).push(MaterialPageRoute(
  //         builder: (context) => KamilaMainScreen()
  //     ));

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('KKenglish'),
        backgroundColor: const Color(0xFF8257E5),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // initialData: ChatRoom,
          stream: FirebaseFirestore.instance.collection('chatRoom').where("userIds", arrayContains: "ysc47YoKUifJXCW3Kwq44hHrOm93").snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data != null) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot message = snapshot.data!.docs[index];

                    if(message['pass'] == 1){

                    }

                    exist.add(Rooms(
                      docImage: message['docImage'],
                      from: message['from'],
                      message: message['message'],
                      name: message['name'],
                      senderName: message['senderName'],
                      time: message['time'],
                      to: message['to'],
                      userIds: message['userIds'],
                    ));

                    // uniquelist = exist
                    //     .where((chat) => seen.add(chat.to))
                    //     .toList();

                    return
                      GestureDetector(
                        onTap: () {
                          //Pass to zero need to UPGRADE
                          FirebaseFirestore.instance
                              .collection('chatRoom').doc(
                              "${message['from']}-ysc47YoKUifJXCW3Kwq44hHrOm93")
                              .collection('messages')
                              .get()
                              .then(
                                (value) =>
                                value.docs.forEach(
                                      (element) {
                                    var docRef = FirebaseFirestore.instance
                                        .collection('chatRoom').doc(
                                        "${message['from']}-ysc47YoKUifJXCW3Kwq44hHrOm93")
                                        .collection('messages')
                                        .doc(element.id);

                                    docRef.update({'new': false});
                                  },
                                ),
                          );
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                                return KamilaChatRooms(room: message);
                              })
                          );
                        },
                        onLongPress: () {
                          Clipboard.setData(
                              ClipboardData(text: message['from']));
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('User id Copied'),
                              ));
                        },
                        child: Container(
                          width: size.width,
                          height: size.width * 0.20,
                          child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(size.width * 0.02),
                                  child: Row(
                                    children: [
                                      ClipOval(
                                        child: Container(
                                            height: size.width * 0.14,
                                            width: size.width * 0.14,
                                            color: AppColors.main,
                                            child: Center(child: Text(
                                              message['senderName'].substring(
                                                  0, 1), style: const TextStyle(
                                                fontSize: 25,
                                                color: Colors.white),))),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.02,
                                      ),
                                      SizedBox(
                                        height: size.width * 0.14,
                                        width: size.width * 0.8,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .start,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Text(
                                                  message['senderName'],
                                                  style: const TextStyle(
                                                      fontSize: 20),
                                                ),
                                                message['time']
                                                    .toDate()
                                                    .toString() ==
                                                    '2021-12-12 12:12:00.000' ?
                                                Text(DateFormat.Hm().format(
                                                    DateTime.now()).toString())
                                                    : DateFormat.MMMMd().format(
                                                    DateTime.now()).toString() ==
                                                    DateFormat.MMMMd()
                                                        .format(
                                                        message['time'].toDate())
                                                        .toString()
                                                    ? Text(DateFormat.Hm()
                                                    .format(
                                                    message['time'].toDate())
                                                    .toString()) :
                                                Text(DateFormat.MMMMd()
                                                    .format(
                                                    message['time'].toDate())
                                                    .toString()),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: size.width * 0.6,
                                                  child: Text(
                                                    message['message'],
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    StreamBuilder<QuerySnapshot>(
                                                        stream: FirebaseFirestore
                                                            .instance.collection(
                                                            'chatRoom').doc(
                                                            '${message['from']}-ysc47YoKUifJXCW3Kwq44hHrOm93')
                                                            .collection(
                                                            "messages").where(
                                                            'authorId',
                                                            isNotEqualTo: "ysc47YoKUifJXCW3Kwq44hHrOm93")
                                                            .where('new',
                                                            isEqualTo: true)
                                                            .snapshots(),
                                                        builder: (context,
                                                            AsyncSnapshot<
                                                                QuerySnapshot> snapshot) {
                                                          if (snapshot
                                                              .connectionState ==
                                                              ConnectionState
                                                                  .active) {
                                                            if (snapshot.data !=
                                                                null) {
                                                              // print('${snapshot.data!.docs[0].id}');
                                                              return snapshot
                                                                  .data!.docs
                                                                  .length == 0 ?
                                                              Container()
                                                                  :
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                    color: AppColors.main,
                                                                    borderRadius: BorderRadius
                                                                        .circular(
                                                                        5)
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      left: 8.0,
                                                                      right: 8.0,
                                                                      bottom: 2.0,
                                                                      top: 2.0),
                                                                  child: Text(
                                                                    '${snapshot
                                                                        .data!
                                                                        .docs
                                                                        .length}',
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white),),
                                                                ),
                                                              );
                                                            } else {
                                                              return Container();
                                                            }
                                                          }
                                                          return Container();
                                                        }),
                                                    const Icon(
                                                      Icons.arrow_forward_ios,
                                                      color: Colors.grey,),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: size.width * 0.01,
                                ),
                                Container(
                                  height: 1,
                                  width: size.width,
                                  color: const Color(0x808257E5),
                                ),
                              ]
                          ),
                        ),
                      );
                  },
                );
              } else {
                return const Center(child: Text('Нет сообщений'),);
              }
            } else {
              return
                exist == [] ? const Center(
                child: CircularProgressIndicator(),)
                   :
                // const Center(child: CircularProgressIndicator(),);
              Column(
                children: uniquelist.map((cone) {
                  return Column(
                      children: [
                  Padding(
                  padding: EdgeInsets.all(size.width*0.02),
                  child: Row(
                  children: [
                  ClipOval(
                  child: Container(
                  height: size.width*0.14,
                  width:size.width*0.14,
                  color: AppColors.main,
                  child: Center(child: Text(cone.senderName.substring(0,1), style: const TextStyle(fontSize: 25, color: Colors.white),))),
                  ),
                  SizedBox(
                  width: size.width*0.02,
                        ),
                        SizedBox(
                          height: size.width*0.14,
                          width:size.width*0.8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    cone.senderName,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  cone.time.toDate().toString() == '2021-12-12 12:12:00.000' ?
                                  Text(DateFormat.Hm().format(DateTime.now()).toString())
                                      : DateFormat.MMMMd().format(DateTime.now()).toString() == DateFormat.MMMMd().format(cone.time.toDate()).toString()
                                      ? Text(DateFormat.Hm().format(cone.time.toDate()).toString()) :
                                  Text(DateFormat.MMMMd().format(cone.time.toDate()).toString()),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width:size.width*0.6,
                                    child: Text(
                                      cone.message,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  const  Icon(Icons.arrow_forward_ios, color: Colors.grey,),
                                ],
                              ),
                            ],
                          ),
                        )])),
                        SizedBox(
                          height: size.width*0.01,
                        ),
                        Container(
                          height: 1,
                          width: size.width,
                          color: const Color(0x808257E5),
                        ),
                      ],
                  );
                }).toList(),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.main,
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) {
                return AllChatsJustForKamila();
              })
          );
        },
        child: Icon(Icons.search, color: Colors.white,),
      ),
    );
  }
}



class Rooms {
  String docImage;
  String from;
  String message;
  String name;
  String senderName;
  Timestamp time;
  String to;
  List<dynamic> userIds;


  Rooms({
    required this.name,
    required this.from,
    required this.message,
    required this.time,
    required this.senderName,
    required this.to,
    required this.userIds,
    required this.docImage,
  });

  // dynamic toJson() => {
  //   'name': name,
  //   'from': from,
  //   'message': message,
  //   'time': time,
  //   'senderName': senderName,
  //   'to': to,
  //   'userIds': userIds,
  //   'docImage': docImage,
  // };
  //
  // factory Rooms.fromJson(Map<String, dynamic> json) {
  //   return Rooms(
  //     name: json['name'],
  //     from: json['from'],
  //     message: json['message'],
  //     time: json['time'],
  //     senderName: json['senderName'],
  //     to: json['to'],
  //     userIds: json['userIds'],
  //     docImage: json['docImage'],
  //   );
  // }
}