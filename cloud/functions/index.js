const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.updateTimestamp = functions.firestore
    .document("Esp32/{docId}")
    .onUpdate((change, context) => {
      const newValue = change.after.data();
      if (newValue.timestamp === 0.00) {
        return change.after.ref.update({
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
        });
      }

      return null; // Nothing to update
    });
