const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

var msgData;

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
          console.log('Pushed them all');
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
          console.log('Pushed them all');
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
          console.log('Pushed them all');
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
          console.log('Pushed them all');
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
  const before = change.before.data();
  const after = change.after.data();
  const residentAssociationId = before.residentAssociationId;
  const userId = change.before.id;

  if (before.isAdmin == false && after.isAdmin == true) {

    admin.firestore().collection('Users').where('residentAssociationId', '==', residentAssociationId).get().then((snapshots) => {
      var tokens = [];

      if (snapshots.empty) {
        console.log('No Devices');
      }
      else {
        for (var token of snapshots.docs) {
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
            'type': 'madeAdmin',
            'id': userId,
          }
        }

        return admin.messaging().sendToDevice(tokens, payload).then((response) => {
          console.log('Pushed them all');
        }).catch((err) => {
          console.log(err);
        })
      }
    })
  }
  else return null;
})

exports.removeResidentTrigger = functions.firestore.document(
  'Users/{UsersId}'
).onUpdate((change, context) => {
  const after = change.after.data();
  const token = after.userToken;

  if (after.residentAssociationId == '') {

    var payload = {
      'notification': {
        'title': 'removed resident',
        'body': '',
      },
      'data': {
        'type': 'removedResident',
      }
    }

    return admin.messaging().sendToDevice(token, payload).then((response) => {
      console.log('Pushed them all');
    }).catch((err) => {
      console.log(err);
    })
  }
})

