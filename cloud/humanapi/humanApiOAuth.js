var crypto = require('crypto');
var moment = require('moment');
var _ = require('underscore');

var saveHumanApiOAuthData = function(req, res) {
		// get records for current user
	new Parse.Query('OAuthFitbit').equalTo('user_owner', req.user).equalTo('oauth_type', 'humanapi').find().then(function(resultuser) {
		// check if record for current user exists
		if (resultuser[0]) {

			// update record
			resultuser[0].set('OAuth_Token', req.params.oauth_token);
			resultuser[0].set('Public_Token', req.params.public_token);
			resultuser[0].set('oauth_type', 'humanapi');
			resultuser[0].save().then(function() {
				// get fitbit data and save to parse
				getUsersDataFromHumanApi(req.user).then(function(importRecord) {
					res.success(importRecord);
				}, function(error) {
					res.success(error);
				});

			});
		} else {

			// create new record 
			var oauthFitbit = Parse.Object.extend("OAuthFitbit");
			var oauthdata = new oauthFitbit();
			oauthdata.set('OAuth_Token', req.params.oauth_token);
			oauthdata.set('oauth_type', 'humanapi');
			oauthdata.set('Public_Token', req.params.public_token);
			oauthdata.set('user_owner', req.user);
			oauthdata.save().then(function() {
				// get fitbit data and save to parse
				getUsersDataFromHumanApi(req.user).then(function(importRecord) {
					res.success(importRecord);
				}, function(error) {
					res.success(error);
				});
			});

		}
	});

};


/**
 * get humanApi data for current user and set to Parse 
 * return @promise
 */
var getUsersDataFromHumanApi = function(user) {

	return new Parse.Query('OAuthFitbit').include('user_owner').equalTo('user_owner', user).equalTo('oauth_type', 'humanapi').find().then(function(oauth_data) {
		var oauth_token = oauth_data[0].get('OAuth_Token');

		var date = new Date();
		date.setDate(date.getDate() - 1);
	
		var yesterdayYYYYMMDDformat = moment().subtract('days', 1).format('YYYYMMDD');
		yesterdayYYYYMMDDformat += 'T000000Z';
		var oauth_method = 'GET';

		var humanApiDataResult = [];
		var humanApiPromisesArray = [];

		// create new ActivitiesImport record in Parse
		var ActivitiesImport = Parse.Object.extend("ActivitiesImport");
		var activities_import = new ActivitiesImport();

		// get activities data from humanApi and save to Parse
		var url = 'https://api.humanapi.co/v1/human/activities/summaries?access_token='+oauth_token+'&updated_since='+yesterdayYYYYMMDDformat;
		humanApiPromisesArray.push(getDataFromHumanApi(url,oauth_method).then(function(activities){
			if(typeof(activities) !== 'undefined'){	
				activities_import.set('Steps', activities.steps);
				activities_import.set('Calories', activities.calories);
			}

		},function(error){
			console.log(error);
		}));

		// get heart data from humanApi and save to Parse
		url = 'https://api.humanapi.co/v1/human/heart_rate?access_token='+oauth_token;
		humanApiPromisesArray.push(getDataFromHumanApi(url,oauth_method).then(function(heartData){
			if(typeof(heartData) !== 'undefined'){	
				activities_import.set('RestingHR', 0);
				activities_import.set('NormalHR', heartData.value);
				activities_import.set('ExertiveHR', 0);
			}
		},function(error){
			console.log(error);
		}));

		// get sleep data from humanApi and save to Parse
		url = 'https://api.humanapi.co/v1/human/sleeps/summaries?access_token='+oauth_token;
		humanApiPromisesArray.push(getDataFromHumanApi(url,oauth_method).then(function(sleep){		
			if(typeof(sleep) !== 'undefined'){			
				activities_import.set('TotalSleepMinutes', sleep.timeAsleep);			
			}
			else {
				activities_import.set('TotalSleepMinutes', 0);
			}
			activities_import.set('TotalSleepRecords', 0);
			activities_import.set('TotalTimeInBed', 0);
		
		},function(error){
			console.log(error);
		}));

		return Parse.Promise.when(humanApiPromisesArray).then(function(){
			activities_import.set('Date', date);
			activities_import.set('source', 'humanapi');
			activities_import.set('user', user);
			return activities_import.save();
		})

	});
	
}

var getDataFromHumanApi = function(url, oauth_method){
	var yesterdayYYYY_MM_DDformat = moment().subtract('days', 1).format('YYYY-MM-DD');
	return Parse.Cloud.httpRequest({
		url: url,
		method: oauth_method
	}).then(function(httpResponse){

		var humanApiData= JSON.parse(httpResponse.text);

		if(Array.isArray(humanApiData)){
			var humanData;

			_.each(humanApiData,function(humanApi){			
				if(humanApi.date == yesterdayYYYY_MM_DDformat){
					humanData = humanApi;
				}				
			});
			return humanData;
		}
		else {
			return humanApiData;
		}

		

	},function(error){
		return error;
	});
}




//exports
exports.saveHumanApiOAuthData  = saveHumanApiOAuthData;