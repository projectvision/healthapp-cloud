var crypto = require('crypto');
var moment = require('moment');
var _ = require('underscore');

var getHumanApiData = function(req, res) {

	var oauth_user = req.user;
	new Parse.Query('OAuthFitbit').equalTo('user_owner', oauth_user).equalTo('oauth_type', 'humanapi').find().then(function(oauth_data) {

		var date = new Date();
		date.setDate(date.getDate() - 1);

		var oauth_token = oauth_data[0].get('OAuth_Token');

		var yesterdayYYYYMMDDformat = moment().subtract('days', 1).format('YYYYMMDD');
		yesterdayYYYYMMDDformat += 'T000000Z';
		var oauth_method = 'GET';

		var humanApiDataResult = [];
		var humanApiPromisesArray = [];

		// create new ActivitiesImport record in Parse
		var ActivitiesImport = Parse.Object.extend("ActivitiesImport");
		var activities_import = new ActivitiesImport();

		// get activities data from humanApi and save to Parse
		var url = 'https://api.humanapi.co/v1/human/activities/summaries?access_token=' + oauth_token + '&updated_since=' + yesterdayYYYYMMDDformat;
		humanApiPromisesArray.push(getDataFromHumanApi(url, oauth_method).then(function(activities) {
			if (typeof(activities) !== 'undefined') {
				activities_import.set('Steps', activities.steps);
				activities_import.set('Calories', activities.calories);
			}
			else{
				activities_import.set('Steps', 0);
				activities_import.set('Calories', 0);
			}
		}, function(error) {
			console.log(error);
		}));

		// get heart data from humanApi and save to Parse
		url = 'https://api.humanapi.co/v1/human/heart_rate?access_token=' + oauth_token;
		humanApiPromisesArray.push(getDataFromHumanApi(url, oauth_method).then(function(heartData) {
			if (typeof(heartData) !== 'undefined') {
				activities_import.set('RestingHR', 0);
				activities_import.set('NormalHR', heartData.value);
				activities_import.set('ExertiveHR', 0);
			}
			else{
				activities_import.set('RestingHR', 0);
				activities_import.set('NormalHR', 0);
				activities_import.set('ExertiveHR', 0);
			}
		}, function(error) {
			console.log(error);
		}));

		// get sleep data from humanApi and save to Parse
		url = 'https://api.humanapi.co/v1/human/sleeps/summaries?access_token=' + oauth_token;
		humanApiPromisesArray.push(getDataFromHumanApi(url, oauth_method).then(function(sleep) {
			if (typeof(sleep) !== 'undefined') {
				activities_import.set('TotalSleepMinutes', sleep.timeAsleep);
			} else {
				activities_import.set('TotalSleepMinutes', 0);
			}
			activities_import.set('TotalSleepRecords', 0);
			activities_import.set('TotalTimeInBed', 0);

		}, function(error) {
			console.log(error);
		}));

		Parse.Promise.when(humanApiPromisesArray).then(function() {
			activities_import.set('Date', date);
			activities_import.set('source', 'humanapi');
			activities_import.set('user', oauth_user);
			activities_import.save().then(function(importRecord) {
				res.success(importRecord);
			}, function(error) {
				res.success(error);
			});
		})
	});



};

var getDataFromHumanApiJob = function(req, status) {
	var allPromises = [];
	var savePromises = [];
	new Parse.Query('OAuthFitbit').include('user_owner').equalTo('oauth_type', 'humanapi').find().then(function(all_oauth_data) {
		_.each(all_oauth_data, function(oauth_data) {

			var oauth_user = oauth_data.get('user_owner');

			var date = new Date();
			date.setDate(date.getDate() - 1);

			var oauth_token = oauth_data.get('OAuth_Token');

			var yesterdayYYYYMMDDformat = moment().subtract('days', 1).format('YYYYMMDD');
			yesterdayYYYYMMDDformat += 'T000000Z';
			var oauth_method = 'GET';

			var humanApiDataResult = [];
			var humanApiPromisesArray = [];

			// create new ActivitiesImport record in Parse
			var ActivitiesImport = Parse.Object.extend("ActivitiesImport");
			var activities_import = new ActivitiesImport();

			// get activities data from humanApi and save to Parse
			var url = 'https://api.humanapi.co/v1/human/activities/summaries?access_token=' + oauth_token + '&updated_since=' + yesterdayYYYYMMDDformat;
			humanApiPromisesArray.push(getDataFromHumanApi(url, oauth_method).then(function(activities) {
				if (typeof(activities) !== 'undefined') {
					activities_import.set('Steps', activities.steps);
					activities_import.set('Calories', activities.calories);
				}
				else {
					activities_import.set('Steps', 0);
					activities_import.set('Calories', 0);
				}
			}, function(error) {
				console.log(error);
			}));

			// get heart data from humanApi and save to Parse
			url = 'https://api.humanapi.co/v1/human/heart_rate?access_token=' + oauth_token;
			humanApiPromisesArray.push(getDataFromHumanApi(url, oauth_method).then(function(heartData) {
				if (typeof(heartData) !== 'undefined') {
					activities_import.set('RestingHR', 0);
					activities_import.set('NormalHR', heartData.value);
					activities_import.set('ExertiveHR', 0);
				} else {
					activities_import.set('RestingHR', 0);
					activities_import.set('NormalHR', 0);
					activities_import.set('ExertiveHR', 0);
				}
			}, function(error) {
				console.log(error);
			}));

			// get sleep data from humanApi and save to Parse
			url = 'https://api.humanapi.co/v1/human/sleeps/summaries?access_token=' + oauth_token;
			humanApiPromisesArray.push(getDataFromHumanApi(url, oauth_method).then(function(sleep) {
				if (typeof(sleep) !== 'undefined') {
					activities_import.set('TotalSleepMinutes', sleep.timeAsleep);
				} else {
					activities_import.set('TotalSleepMinutes', 0);
				}
				activities_import.set('TotalSleepRecords', 0);
				activities_import.set('TotalTimeInBed', 0);

			}, function(error) {
				console.log(error);
			}));

			allPromises.push(Parse.Promise.when(humanApiPromisesArray).then(function() {
				activities_import.set('Date', date);
				activities_import.set('source', 'humanapi');
				activities_import.set('user', oauth_user);
				activities_import.save();
			}));
		});
		Parse.Promise.when(allPromises).then(function() {
			Parse.Promise.when(savePromises).then(function() {
				status.success('successfully fetched');
			})
		})
	});

}


var getDataFromHumanApi = function(url, oauth_method) {
	var yesterdayYYYY_MM_DDformat = moment().subtract('days', 1).format('YYYY-MM-DD');
	return Parse.Cloud.httpRequest({
		url: url,
		method: oauth_method
	}).then(function(httpResponse) {

		var humanApiData = JSON.parse(httpResponse.text);

		if (Array.isArray(humanApiData)) {
			var humanData;

			_.each(humanApiData, function(humanApi) {
				if (humanApi.date == yesterdayYYYY_MM_DDformat) {
					humanData = humanApi;
				}
			});
			return humanData;
		} else {
			return humanApiData;
		}



	}, function(error) {
		return error;
	});
}



//exports
exports.getDataFromHumanApiJob = getDataFromHumanApiJob;
exports.getHumanApiData = getHumanApiData;