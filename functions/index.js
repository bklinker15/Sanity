const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);


exports.checkBudget = functions.https.onRequest((req, res) => {
  //create database ref
  console.log("HELLO :_P");
  var db = admin.firestore();

  db.collection('Users').get()
    .then((snapshot) => {
        snapshot.forEach((doc) => {
            var username = doc.id;
            //console.log(username);
            var userBudgetsRef = db.collection('Users').doc(username).collection('Budgets');
            const now = Date.now();
            var budgetQuery = userBudgetsRef.get()
              .then(snapshot => {
                  snapshot.forEach(doc2 => {
                      var budgetName = doc2.id;
                      var budgetRef = userBudgetsRef.doc(budgetName);
                      //console.log(budgetName);
                      var doc3 = doc2.data();
                        var resetInterval = doc3.resetInterval;
                        var resetDate = doc3.resetDate;
                        var budgetRemaining = doc3.budgetRemaining;
                        var totalBudget = doc3.totalBudget;
                        var totalHistory;
                        var remainingHistory;
                        totalHistory = doc3.previousBudgetLimit;
                        remainingHistory = doc3.previousBudgetRemains;


                      if (resetDate < now) {
                        console.log(username + "  " + budgetName);
                        console.log("resetInterval " + resetInterval);
                        console.log("resetDate: " + resetDate);
                        console.log("budgetRemaining: " + budgetRemaining);
                        console.log("totalBudget: " + totalBudget);
                        var millisecondOffset = resetInterval * 24 * 60 * 60 * 1000;
                        var newDate = new Date();
                        newDate.setTime( now + millisecondOffset);
                        //need to update lastReset, resetDate, budgetRemaining, and budgetHistory stuff

                        if (totalHistory === undefined) {
                          totalHistory = [totalBudget];
                          remainingHistory = [budgetRemaining];
                        }
                        else {
                          totalHistory.push(totalBudget);
                          remainingHistory.push(budgetRemaining);
                        }
                        console.log("remainingHistory: " + remainingHistory);


                        var budgetUpdate = budgetRef.update({
                          lastReset: now,
                          resetDate: newDate,
                          budgetRemaining: totalBudget,
                          previousBudgetLimit: totalHistory,
                          previousBudgetRemains: remainingHistory,
                        });
                        
                      }
                  });
              })
              .catch(err => {
                console.log('Error getting documents', err);
              });



      });
    })
    .catch((err) => {
        console.log('Error getting documents', err);
    });


  res.redirect(200);

});
