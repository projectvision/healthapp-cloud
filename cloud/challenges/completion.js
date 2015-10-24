var http = require('http');
var _ = require('underscore');
var moment = require('moment');

/**
 * Safe division preventing division to zero
 *
 * @param a
 * @param b
 * @returns {number}
 * @private
 */
function _safe_perc(a, b) {
  if (b !== 0) {
    return Math.round(a / b * 100);
  }
  return 0;
}

/**
 * Calculate Challenges Completion Rate over 2 week periods
 *
 * @param req
 * @param res
 */
function calculateChallengesCompletionRateOverPeriod(req, status) {

  //var currentUser = req.user;
  var challengesArray = [];
  var usersChallengesArray = [];
  var resultsArray = [];
  var usersPromises = [];
  var usersSavePromises = [];


  new Parse.Query('User').find().then(function(allusers) {
    // Instantiate UserChallenges object
    _.each(allusers, function(currentUser) {

      var UserChallenges = Parse.Object.extend('UserChallenges');

      // Fetch all challenges
      var Challenges = Parse.Object.extend("Challenges");
      var challengesQuery = new Parse.Query(Challenges);
      challengesQuery.include(['GroupID', 'GroupID.FocusID']);

      challengesArray.push(challengesQuery.find().then(function(challenges) {

        var query = new Parse.Query(UserChallenges);

        query.equalTo('user', currentUser);

        // Fetch challenges associated with current user
        // and filter them one-by-one
        usersChallengesArray.push(query.find().then(function(data) {
          // ASSUMPTION: Focus id is predefined entitites
          var results = {
            'completed_2weeks': {
              1: [],
              2: [],
              3: []
            },
            'completed_4weeks': {
              1: [],
              2: [],
              3: []
            },
            'accepted_2weeks': {
              1: [],
              2: [],
              3: []
            },
            'accepted_4weeks': {
              1: [],
              2: [],
              3: []
            }
          };
          _.each(data, function(e) {

            // Get challenge from challenges list
            var currentChallenge = _.find(challenges, function(c) {
              return c.get('challengeId') == e.get('challengeId');
            });

            if (currentChallenge) {

              var currentFocus = currentChallenge.get('GroupID').get('FocusID').get("focusId");
              // Calculate amount of day passed since the challenge was completed
              var days = moment().diff(e.get('completedAt'), 'days');
              if (e.get('completed')) {
                if (days < 14) {
                  results['completed_2weeks'][currentFocus].unshift(e);
                }
                if (days < 28 && days >= 14) {
                  results['completed_4weeks'][currentFocus].unshift(e);
                }
              }

              // Calculate amount of day passed since the challenge was accepted
              var days2 = moment().diff(e.get('acceptedAt'), 'days');

              if (days2 < 14) {
                results['accepted_2weeks'][currentFocus].unshift(e);
              }
              if (days2 < 28 && days2 >= 14) {
                results['accepted_4weeks'][currentFocus].unshift(e);
              }
            }
          });

          results['completionRate_2weeks'] = {};
          results['completionRate_4weeks'] = {};

          // For each focus id
          // ASSUMPTION: Focus id is predefined entitites
          _.each([1, 2, 3], function(focusId) {
            results['completionRate_2weeks'][focusId] = _safe_perc(results['completed_2weeks'][focusId].length, results['accepted_2weeks'][focusId].length);
            results['completionRate_4weeks'][focusId] = _safe_perc(results['completed_4weeks'][focusId].length, results['accepted_4weeks'][focusId].length);
          });
          resultsArray.push(results);

          usersPromises.push(

            new Parse.Query('UserTable').equalTo('Username', currentUser).find().then(function(resultuser) {

              if (resultuser[0]) {

                resultuser[0].set('PercentDietChallenges', results.completionRate_2weeks[2]);
                resultuser[0].set('PercentFitnessChallenges', results.completionRate_2weeks[1]);
                resultuser[0].set('PercentStressChallenges', results.completionRate_2weeks[3]);

                resultuser[0].set('PercentDietChallengesLast', results.completionRate_4weeks[2]);
                resultuser[0].set('PercentFitnessChallengesLast', results.completionRate_4weeks[1]);
                resultuser[0].set('PercentStressChallengesLast', results.completionRate_4weeks[3]);


                usersSavePromises.push(resultuser[0].save());
              } else {



                var UT = Parse.Object.extend("UserTable");
                var usertable = new UT();

                usertable.set('PercentDietChallenges', results.completionRate_2weeks[2]);
                usertable.set('PercentFitnessChallenges', results.completionRate_2weeks[1]);
                usertable.set('PercentStressChallenges', results.completionRate_2weeks[3]);

                usertable.set('PercentDietChallengesLast', results.completionRate_4weeks[2]);
                usertable.set('PercentFitnessChallengesLast', results.completionRate_4weeks[1]);
                usertable.set('PercentStressChallengesLast', results.completionRate_4weeks[3]);


                usertable.set('Username', currentUser);

                usersSavePromises.push(usertable.save());

              }

            })
          );



        }));
      }));



    });
    Parse.Promise.when(challengesArray).then(function() {
      Parse.Promise.when(usersChallengesArray).then(function() {
        Parse.Promise.when(usersPromises).then(function() {
          Parse.Promise.when(usersSavePromises).then(function() {
            status.success('Average data successfully updated');
          });
        });

      });
    });


  });

}

exports.getChallengesCompletionRateOverPeriod = calculateChallengesCompletionRateOverPeriod;

function completeChallenge(req, res) {
  var user = Parse.User.current();
  var UserChallenges = Parse.Object.extend('UserChallenges');
  return new Parse.Query(UserChallenges).equalTo('user', user)
                    .equalTo('challengeId', req.params.challengeId)
                    .descending('acceptedAt')
                    .first().then(function(userChallenge) {
      if (userChallenge) {
        userChallenge.set('completed', 1);
        userChallenge.set('completedAt', new Date());
        return userChallenge.save();
      } else {
        return Parse.Promise.error('User challenge not found');
      }
    }
  ).then(function(result) {
      return calculateChallengesCompletionRate(user);
    }
  ).then(function(result) {
      var Challenge = Parse.Object.extend('Challenges');
      return new Parse.Query(Challenge).equalTo('challengeId', req.params.challengeId).first();
  }).then(function(challenge) {
      if (challenge) {
        var earnedPoints = 0;
        if (!user.get('earnedPoint')) {
          earnedPoints = challenge.get('points');
        } else {
          earnedPoints = user.get('earnedPoint') + challenge.get('points');
        }
        return user.set('earnedPoint', earnedPoints).save();
      } else {
        return Parse.Promise.error('Challenge not found.');
      }
  }).then(function(currentUser) {
      res.success('Challenge completed.');
  },
    function(error) {
      res.error(error);
  });
}

exports.completeChallenge = completeChallenge;

function calculateChallengesCompletionRate(user) {
  var userChallenges = [];
  var result;
  var results = {
    'completed_2weeks': {
      1: [],
      2: [],
      3: []
    },
    'completed_4weeks': {
      1: [],
      2: [],
      3: []
    },
    'accepted_2weeks': {
      1: [],
      2: [],
      3: []
    },
    'accepted_4weeks': {
      1: [],
      2: [],
      3: []
    }
  };

  if (!user) {
    return Parse.Promise.error('Invalid user.');
  }

  var UserChallenges = Parse.Object.extend('UserChallenges');
  var fourWeeksAgo = new Date();
  fourWeeksAgo.setDate(fourWeeksAgo.getDate() - 29);
  // user challenges
  var userChallengesQuery = new Parse.Query(UserChallenges).equalTo('user', user).greaterThan('acceptedAt', fourWeeksAgo);
  return userChallengesQuery.find().then(function(challenges) {
      if (challenges) {
        userChallenges = challenges;
        var userChallengesIds = [];

        _.each(userChallenges, function(o) {
          userChallengesIds.push(o.get('challengeId'));
        });

        var Challenges = Parse.Object.extend("Challenges");
        // collect only challenges the user accepted.
        return new Parse.Query(Challenges).include(['GroupID', 'GroupID.FocusID']).containedIn('challengeId', userChallengesIds).find();
      } else {
        return Parse.Promise.error("User challenges not found.");
      }
    }
  ).then(function(challenges) {
      if (challenges) {
        _.each(userChallenges, function(userChallenge) {
          // Get challenge from challenges list
          var currentChallenge = _.find(challenges, function(challenge) {
            return challenge.get('challengeId') == userChallenge.get('challengeId');
          });

          if (currentChallenge) {
            var currentFocus = currentChallenge.get('GroupID').get('FocusID').get('focusId');
            // Calculate amount of day passed since the challenge was completed
            var completedAtInDays = moment().diff(userChallenge.get('completedAt'), 'days');
            // Calculate amount of day passed since the challenge was accepted
            var acceptedAtInDays = moment().diff(userChallenge.get('acceptedAt'), 'days');
            // accamulate completed challenges 
            // skip completed and accepted challenges from future
            if ((completedAtInDays < 14 && completedAtInDays >= 0) &&
                (acceptedAtInDays < 14 && acceptedAtInDays >= 0) &&
                userChallenge.get('completed')) {
              results['completed_2weeks'][currentFocus].unshift(userChallenge);
            }
            if ((completedAtInDays < 28 && completedAtInDays >= 14) &&
                (acceptedAtInDays < 28 && acceptedAtInDays >= 14) &&
                userChallenge.get('completed')) {
              results['completed_4weeks'][currentFocus].unshift(userChallenge);
            }

            if (acceptedAtInDays >= 0 && acceptedAtInDays < 14) {
              results['accepted_2weeks'][currentFocus].unshift(userChallenge);
            }
            if (acceptedAtInDays < 28 && acceptedAtInDays >= 14) {
              results['accepted_4weeks'][currentFocus].unshift(userChallenge);
            }
          }
        });

        results['completionRate_2weeks'] = {};
        results['completionRate_4weeks'] = {};

        // For each focus id
        // ASSUMPTION: Focus id is predefined entitites
        _.each([1, 2, 3], function(focusId) {
          results['completionRate_2weeks'][focusId] = _safe_perc(results['completed_2weeks'][focusId].length, results['accepted_2weeks'][focusId].length);
          results['completionRate_4weeks'][focusId] = _safe_perc(results['completed_4weeks'][focusId].length, results['accepted_4weeks'][focusId].length);
        });
        return new Parse.Query('UserTable').equalTo('Username', user).find();
      } else {
        return Parse.Promise.error("Challenges not found.");
      }
    }
  ).then(function(resultuser) {
      if (resultuser[0]) {
        resultuser[0].set('PercentFitnessChallenges', results.completionRate_2weeks[1]);
        resultuser[0].set('PercentDietChallenges', results.completionRate_2weeks[2]);
        resultuser[0].set('PercentStressChallenges', results.completionRate_2weeks[3]);

        resultuser[0].set('PercentFitnessChallengesLast', results.completionRate_4weeks[1]);
        resultuser[0].set('PercentDietChallengesLast', results.completionRate_4weeks[2]);
        resultuser[0].set('PercentStressChallengesLast', results.completionRate_4weeks[3]);

        return resultuser[0].save();
      } else {
        return createRecordInUserTable(results, user);
      }
    }
  );
}

function createRecordInUserTable(results, user) {
  var UT = Parse.Object.extend("UserTable");
  var usertable = new UT();

  usertable.set('PercentFitnessChallenges', results.completionRate_2weeks[1]);
  usertable.set('PercentDietChallenges', results.completionRate_2weeks[2]);
  usertable.set('PercentStressChallenges', results.completionRate_2weeks[3]);

  usertable.set('PercentFitnessChallengesLast', results.completionRate_4weeks[1]);
  usertable.set('PercentDietChallengesLast', results.completionRate_4weeks[2]);
  usertable.set('PercentStressChallengesLast', results.completionRate_4weeks[3]);

  usertable.set('Username', user);
  usertable.set('DailyHR', 0);
  usertable.set('DailyHRLast', 0);
  usertable.set('DailyKcalBurn', 0);
  usertable.set('DailyKcalBurnLast', 0);
  usertable.set('DailySleep', 0);
  usertable.set('DailySleepLast', 0);
  usertable.set('DailySteps', 0);
  usertable.set('DailyStepsLast', 0);
  usertable.set('MRN', 0);

  return usertable.save();
}