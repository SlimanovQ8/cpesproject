const functions = require("firebase-functions");

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
/* eslint-disable max-len */
const admin = require("firebase-admin");
admin.initializeApp();
exports.Test = functions.firestore.document("Users/{zrga}")
    .onUpdate((change, context) => {
      console.log("zrga");
      const newValue = change.after.data();
      console.log(newValue);
      if (newValue.a.localeCompare("true") != 0) {
        const payload = {
          notification: {
            title: "Car Accepted",
            tag: "CarStatus",
            click_action: "FLUTTER_NOTIFICATION_CLICK",
            // eslint-disable-next-line max-len

            // eslint-disable-next-line max-len
            body: "Hello " + " Your Car " + "(" + ")" + " is Accepted!",
          },
          data: {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "title": "Car Accepted",
            "tag": "CarStatus",
            "sound": "default",
            "status": "done",
            "screen": "MyCars",
            // eslint-disable-next-line max-len
            "body": "Hello " + " Your Car " + "(" + ")" + " is Accepted!",
          },
        };

        const previousValue = change.before.data();
        console.log(previousValue);
        console.log(change.after.data);
        return admin.messaging().sendToDevice(newValue.deviceID, payload);
      } else {
        return;
      }
    });
