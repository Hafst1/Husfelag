const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

//const db = admin.firestore();
//const fcm = admin.messaging();

var msgData;
var today = new Date();

exports.newMeetingTrigger = functions.firestore.document(
  'ResidentAssociations/{ResidentAssociationId}/Meetings/{MeetingId}'
).onCreate((snapshot, context) => {
  msgData = snapshot.data();
  const authorId = msgData.authorId;

  admin.firestore().doc('Users/' + authorId).get().then(userDoc => {
    const residentAssociationId = userDoc.get('residentAssociationId');
    const authorToken = userDoc.get('userToken');


    admin.firestore().collection('Users').where('residentAssociationId', '==', residentAssociationId).get().then((snapshots) => {
      var tokens = [];

      if (snapshots.empty) {
        console.log('No Devices');
      }
      else {
        for (var token of snapshots.docs) {
          if (token.data().userToken != authorToken) {
            tokens.push(token.data().userToken);
            console.log("User: ");
            console.log(token.data().name);
            console.log("UserToken: ");
            console.log(token.data().userToken);
          }
        }
        var payload = {
          'notification': {
            'title': 'Nýr Fundur: ' + msgData.title,
            'body': msgData.description,
            'sound': 'default'
          },
          'data': {
            'residentAssociationId': residentAssociationId,
            'type': 'addedMeeting',
          }
        }

        return admin.messaging().sendToDevice(tokens, payload).then((response) => {
          console.log('PUshed them alll');
        }).catch((err) => {
          console.log(err);
        })
      }
    })
  })
})

exports.deleteMeetingTrigger = functions.firestore.document(
  'ResidentAssociations/{ResidentAssociationId}/Meetings/{MeetingId}'
).onDelete((snapshot, context) => {
  msgData = snapshot.data();
  const authorId = msgData.authorId;

  admin.firestore().doc('Users/' + authorId).get().then(userDoc => {
    const residentAssociationId = userDoc.get('residentAssociationId');
    const authorToken = userDoc.get('userToken');


    admin.firestore().collection('Users').where('residentAssociationId', '==', residentAssociationId).get().then((snapshots) => {
      var tokens = [];

      if (snapshots.empty) {
        console.log('No Devices');
      }
      else {
        for (var token of snapshots.docs) {
          if (token.data().userToken != authorToken) {
            tokens.push(token.data().userToken);
          }
        }
        var payload = {
          'notification': {
            'title': 'Fundur fjarlægður: ' + msgData.title,
            'body': msgData.description,
            'sound': 'default'
          },
          'data': {
            'residentAssociationId': residentAssociationId,
            'type': 'deletedMeeting',
          }
        }

        return admin.messaging().sendToDevice(tokens, payload).then((response) => {
          console.log('PUshed them alll');
        }).catch((err) => {
          console.log(err);
        })
      }
    })
  })
})


exports.newConstructionTrigger = functions.firestore.document(
  'ResidentAssociations/{ResidentAssociationId}/Constructions/{ConstructionId}'
).onCreate((snapshot, context) => {
  msgData = snapshot.data();
  const authorId = msgData.authorId;

  admin.firestore().doc('Users/' + authorId).get().then(userDoc => {
    const residentAssociationId = userDoc.get('residentAssociationId');
    const authorToken = userDoc.get('userToken');

    admin.firestore().collection('Users').where('residentAssociationId', '==', residentAssociationId).get().then((snapshots) => {
      var tokens = [];

      if (snapshots.empty) {
        console.log('No Devices');
      }
      else {
        for (var token of snapshots.docs) {
          if (token.data().userToken != authorToken) {
            tokens.push(token.data().userToken);
          }
        }
        var payload = {
          'notification': {
            'title': 'Ný Framkvæmd: ' + msgData.title,
            'body': msgData.description,
          },
          'data': {
            'residentAssociationId': residentAssociationId,
            'type': 'addedConstruction',
          }
        }

        return admin.messaging().sendToDevice(tokens, payload).then((response) => {
          console.log('PUshed them alll');
        }).catch((err) => {
          console.log(err);
        })
      }
    })
  })
})

exports.deleteConstructionTrigger = functions.firestore.document(
  'ResidentAssociations/{ResidentAssociationId}/Constructions/{ConstructionsId}'
).onDelete((snapshot, context) => {
  msgData = snapshot.data();
  const authorId = msgData.authorId;

  admin.firestore().doc('Users/' + authorId).get().then(userDoc => {
    const residentAssociationId = userDoc.get('residentAssociationId');
    const authorToken = userDoc.get('userToken');


    admin.firestore().collection('Users').where('residentAssociationId', '==', residentAssociationId).get().then((snapshots) => {
      var tokens = [];

      if (snapshots.empty) {
        console.log('No Devices');
      }
      else {
        for (var token of snapshots.docs) {
          if (token.data().userToken != authorToken) {
            tokens.push(token.data().userToken);
          }
        }
        var payload = {
          'notification': {
            'title': 'Framkvæmd fjarlægð: ' + msgData.title,
            'body': msgData.description,
            'sound': 'default'
          },
          'data': {
            'residentAssociationId': residentAssociationId,
            'type': 'deletedConstruction',
          }
        }

        return admin.messaging().sendToDevice(tokens, payload).then((response) => {
          console.log('PUshed them alll');
        }).catch((err) => {
          console.log(err);
        })
      }
    })
  })
})

exports.updateAdminTrigger = functions.firestore.document(
  'Users/{UsersId}'
).onUpdate((change, context) => {
  // msgData = snapshot.data();
  const before = change.before.data();
  const after = change.after.data();
  const residentAssociationId = before.residentAssociationId;

  console.log("before is ADMIN: " + before.isAdmin);
  console.log("after is ADMIN: " + after.isAdmin);
  console.log("Resident associtaion: " + before.residentAssociationId );

  if (before.isAdmin == false && after.isAdmin == true) {
    console.log(before.name + ' is now Admin');

    admin.firestore().collection('Users').where('residentAssociationId', '==', residentAssociationId).get().then((snapshots) => {
      var tokens = [];

      if (snapshots.empty) {
        console.log('No Devices');
      }
      else {
        for (var token of snapshots.docs) {
          console.log("name: " + token.data().name);
          console.log("token: " + token.data().userToken);
          tokens.push(token.data().userToken);
        }
        var payload = {

          'notification': {
            'title': before.name + ' var gerð/ur að stjórnanda',
            'body': 'Nýr stjórnandi!',
            'sound': 'default'
          },
          'data': {
            'residentAssociationId': residentAssociationId,
            'type': 'newAdmin',
          }
        }

        return admin.messaging().sendToDevice(tokens, payload).then((response) => {
          console.log('PUshed them alll');
        }).catch((err) => {
          console.log(err);
        })
      }
    })
  }
  else return null;
})

