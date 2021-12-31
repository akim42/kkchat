const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotification = functions.firestore
  .document('chatRoom/{groupId1}/messages/{message}')
  .onCreate((snap, context) => {
    const doc = snap.data();
    const idFrom = doc.authorId;
    const idTo = doc.idTo;
    const contentMessage = doc.text;

    // Get push token user to (receive)
    admin
      .firestore()
      .collection('users')
      .where('id', '==', idTo)
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(userTo => {
          if (userTo.data().pushToken && userTo.data().chattingWith !== idFrom) {
            // Get info user from (sent)
            console.log(userTo.data().pushToken);
            admin
              .firestore()
              .collection('users')
              .where('id', '==', idFrom)
              .get()
              .then(querySnapshot2 => {
                querySnapshot2.forEach(userFrom => {
                  console.log(`Found user from: ${userFrom.data().nickname}`);
                  const payload = {
                    notification: {
                      title: userFrom.data().nickname,
                      body: contentMessage,
                      badge: '1',
                      sound: 'default',
                      payload: '',
                    }
                  }
                  // Let push to the target device
                  admin
                    .messaging()
                    .sendToDevice(userTo.data().pushToken, payload);
                });
              });
          } else {
          }
        });
      });
    return null
  });
