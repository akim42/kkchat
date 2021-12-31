import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:kkenglish/core/style.dart';
import 'package:kkenglish/kamila/chat_room_for_kamila.dart';
import 'package:kkenglish/kamila/watch_dog_mode.dart';

class AllChatsJustForKamila extends StatefulWidget {
  const AllChatsJustForKamila({Key? key}) : super(key: key);

  @override
  _AllChatsJustForKamilaState createState() => _AllChatsJustForKamilaState();
}

class _AllChatsJustForKamilaState extends State<AllChatsJustForKamila> {
  List<Rooms> exist = [];
  var seen = Set<String>();
  List<Rooms> uniquelist = [];
  // ChatRoom chatroom = ChatRoom();

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
          stream: FirebaseFirestore.instance.collection('chatRoom').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data != null) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot message = snapshot.data!.docs[index];

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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                                return WatchDogMode(room: message);
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
                                              Expanded(child: Padding(
                                                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                                child: Text("- ${message['name']}", overflow: TextOverflow.ellipsis,style: const TextStyle(fontSize: 20),),
                                              )),
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
        onPressed: (){
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.close),
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
}
