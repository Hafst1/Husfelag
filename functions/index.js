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

        if(snapshots.empty){
          console.log('No Devices');
        }
        else{
          for(var token of snapshots.docs){
            if(token.data().userToken != authorToken){
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
            console.log('PUshed them alll');
            }).catch((err) =>{
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
  
          if(snapshots.empty){
            console.log('No Devices');
          }
          else{
            for(var token of snapshots.docs){
              if(token.data().userToken != authorToken){
                tokens.push(token.data().userToken);
              }
            }
            var payload = {
              'notification': {
                'title': 'Hætt við fund: ' + msgData.title,
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
              }).catch((err) =>{
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

        if(snapshots.empty){
          console.log('No Devices');
        }
        else{
          for(var token of snapshots.docs){
            if(token.data().userToken != authorToken){
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
            }).catch((err) =>{
            console.log(err);
          })
        }
      })
    })
  })
