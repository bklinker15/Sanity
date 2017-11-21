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
            //console.log("1: " + username);
            var userBudgetsRef = db.collection('Users').doc(username).collection('Budgets');
            const now = Date.now();
            var budgetQuery = userBudgetsRef.get()
              .then(snapshot => {
                  snapshot.forEach(budgetdoc => {
                      var budgetName = budgetdoc.id;
                      var budgetRef = userBudgetsRef.doc(budgetName);
                      //console.log(budgetName);
                      let currbudgetdoc = budgetdoc.data();
                      //console.log(currbudgetdoc);
                      var resetInterval = currbudgetdoc.resetInterval;
                      var resetDate = currbudgetdoc.resetDate;
                      var budgetRemaining = currbudgetdoc.budgetRemaining;
                      var totalBudget = currbudgetdoc.totalBudget;
                      var totalHistory;
                      var remainingHistory;
                      totalHistory = currbudgetdoc.previousBudgetLimits;
                      remainingHistory = currbudgetdoc.previousBudgetRemains;
                      //console.log("2: " + username + "  " + budgetName);

                      if ((resetDate < now) && (resetInterval > 0)) {
                        console.log(username + "  " + budgetName);
                        console.log("resetInterval " + resetInterval);
                        console.log("resetDate: " + resetDate);
                        console.log("budgetRemaining: " + budgetRemaining);
                        console.log("totalBudget: " + totalBudget);
                        console.log("totalHistory: " + totalHistory);
                        console.log("remainingHistory: " + remainingHistory);

                        var millisecondOffset = resetInterval * 24 * 60 * 60 * 1000;
                        var newDate = new Date();
                        newDate.setTime( now + millisecondOffset);
                        //need to update lastReset, resetDate, budgetRemaining, and budgetHistory stuff

                        //check array length
                        if(remainingHistory && remainingHistory.length){
                          // not empty
                          totalHistory.push(totalBudget);
                          remainingHistory.push(budgetRemaining);
                        }
                        else {
                          // empty
                          totalHistory = [totalBudget];
                          remainingHistory = [budgetRemaining];
                        }

                        totalBudget = totalBudget + budgetRemaining;

                        if (resetInterval > 0) {
                          var budgetUpdate = budgetRef.update({
                            lastReset: resetDate,
                            resetDate: newDate,
                            budgetRemaining: totalBudget,
                            previousBudgetLimits: totalHistory,
                            previousBudgetRemains: remainingHistory,
                          });
                          console.log("UPDATED " + budgetName);
                        }

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
