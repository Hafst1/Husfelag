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

      admin.firestore().collection('Users').where('residentAssociationId', '==', residentAssociationId).get().then((snapshots) => {
        var tokens = [];

        if(snapshots.empty){
          console.log('No Devices');
        }
        else{
          for(var token of snapshots.docs){
            tokens.push(token.data().userToken);
            console.log('Name');
            console.log(token.data().name);
            console.log('Token');
            console.log(token.data().userToken);
          }
          var payload = {
            "notification": {
              "title": "Nýr Fundur: " + msgData.title,
              "body": msgData.description,
              "sound": "default"
            },
            "data": {
              "title": msgData.title,
              "description": msgData.description,
              "authorId": msgData.authorId,
            }
          }

          return admin.messaging().sendToDevice(tokens, payload).then((response) => {
            console.log('PUshed them alll');
            }).catch((err) =>{
            console.log(err + "eg skrifadi tetta");
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

      admin.firestore().collection('Users').where('residentAssociationId', '==', residentAssociationId).get().then((snapshots) => {
        var tokens = [];

        if(snapshots.empty){
          console.log('No Devices');
        }
        else{
          for(var token of snapshots.docs){
            tokens.push(token.data().userToken);
            console.log('Name');
            console.log(token.data().name);
            console.log('Token');
            console.log(token.data().userToken);
          }
          var payload = {
            "notification": {
              "title": "Ný Framkvæmd: " + msgData.title,
              "body": msgData.description,
            },
            "data": {
              "sendername": msgData.title,
              "message": msgData.description,
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
