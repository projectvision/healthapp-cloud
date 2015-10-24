var crypto = require('crypto');
var moment = require('moment');
var _ = require('underscore');


/**
 * get yesterday fitbit information for current user
 * return fitbit data
 */
var getFitbitData = function(req, res) {

	// get start and end of day during 2 weeks
	var startDayForResult = moment().subtract('days', 1).sod().format();
	var startdate = new Date(startDayForResult);
	var endDayForResult = moment().subtract('days', 1).eod().format();
	var enddate = new Date(endDayForResult);

	// get yesterday fitbit data
	new Parse.Query('ActivitiesImport')
		.descending('Date')
		.equalTo('user', req.user)
		.greaterThan("Date", startdate)
		.lessThan("Date", enddate)
		.find().then(function(yesterdayfitbitdata) {

			// return fitbit data if data exists
			if(yesterdayfitbitdata[0])
				res.success(yesterdayfitbitdata[0]);
			else {
				// get data from fitbit and re-call getFitBitData point
				getUsersDataFromFitbit(req.user).then(function() {
					getFitbitData(req,res);
				}, function(error) {
					res.error(error);
				});

			}
		});


};



/**
 * get fitbit data for current user and set to Parse 
 * return @promise
 */
var getUsersDataFromFitbit = function(user) {
	return new Parse.Query('OAuthFitbit').include('user_owner').equalTo('oauth_type', 'fitbit').equalTo('user_owner', user).find().then(function(oauth_data) {
		var allPromises = [];
		var saveUsersDataPromises = [];
		var results = [];
		var date = new Date();
		date.setDate(date.getDate() - 1);

		var resultsPromiseArray = [];
		var oauth_token = oauth_data[0].get('OAuth_Token');
		var oauth_token_secret = oauth_data[0].get('OAuth_Secret_Token');
		var oauth_user = oauth_data[0].get('user_owner');

		var yesterday = moment().subtract('days', 1).format('YYYY-MM-DD');
		var oauth_method = 'GET';

		// create new ActivitiesImport record in Parse
		var ActivitiesImport = Parse.Object.extend("ActivitiesImport");
		var activities_import = new ActivitiesImport();

		// get sleep data from fitbit and save to Parse
		var url = 'https://api.fitbit.com/1/user/-/sleep/date/' + yesterday + '.json';
		resultsPromiseArray.push(getInformationFromFitbit(url, oauth_token, oauth_token_secret).then(function(httpResponse) {
			var sleepData = JSON.parse(httpResponse.text);
			activities_import.set('TotalTimeInBed', sleepData.summary.totalTimeInBed);
			activities_import.set('TotalSleepMinutes', sleepData.summary.totalMinutesAsleep);
			activities_import.set('TotalSleepRecords', sleepData.summary.totalSleepRecords);
		}));

		// get activities data from fitbit and save to Parse
		url = 'https://api.fitbit.com/1/user/-/activities/date/' + yesterday + '.json';
		resultsPromiseArray.push(getInformationFromFitbit(url, oauth_token, oauth_token_secret).then(function(httpResponse) {
			var activitiesData = JSON.parse(httpResponse.text);
			activities_import.set('Steps', activitiesData.summary.steps);
			activities_import.set('Calories', activitiesData.summary.caloriesOut);
		}));

		// get heart data from fitbit and save to Parse
		url = 'https://api.fitbit.com/1/user/-/heart/date/' + yesterday + '.json';
		resultsPromiseArray.push(getInformationFromFitbit(url, oauth_token, oauth_token_secret).then(function(httpResponse) {
			var heartData = JSON.parse(httpResponse.text);
			activities_import.set('RestingHR', heartData.average[0].heartRate);
			activities_import.set('NormalHR', heartData.average[1].heartRate);
			activities_import.set('ExertiveHR', heartData.average[2].heartRate);
		}));

		return Parse.Promise.when(resultsPromiseArray).then(function() {
			activities_import.set('Date', date);
			activities_import.set('source', 'fitbit');
			activities_import.set('user', oauth_user);
			return activities_import.save();
		});



	});

}

/** 
 * create httpRequest to fitbit
 *  return @promise
 */

var getInformationFromFitbit = function(url, oauth_token, oauth_token_secret) {
	var yesterday = moment().subtract('days', 1).format('YYYY-MM-DD');
	var oauth_method = 'GET';
	var oauth_consumer_key = '3beb033bbff6465c890585faab187acd';
	var oauth_nonce = getRandomString();
	var oauth_signature_method = 'HMAC-SHA1';
	var oauth_timestamp = getTimestamp();
	var oauth_version = '1.0';
	var oauth_signature = getSignature(oauth_method, url, oauth_consumer_key, oauth_nonce, oauth_signature_method, oauth_timestamp, oauth_token, oauth_version, oauth_token_secret);
	var oauth_authorization_header = getAuthorizationHeader(oauth_consumer_key, oauth_nonce, oauth_signature, oauth_signature_method, oauth_timestamp, oauth_token, oauth_version);

	return Parse.Cloud.httpRequest({
		url: url,
		method: oauth_method,
		headers: {
			'Authorization': oauth_authorization_header
		}
	});

}

/** 
 * generate random sting of 10 numbers
 * return @string
 */
var getRandomString = function() {
	var nonce = '';
	for (var i = 0; i < 10; i++) {
		nonce = nonce + Math.floor((Math.random() * 10));
	}
	return nonce;
}

/** 
 * create and encode signature from oauth parameters
 * return encodeSignature
 */
var getSignature = function(oauth_method, url, oauth_consumer_key, oauth_nonce, oauth_signature_method, oauth_timestamp, oauth_token, oauth_version, oauth_token_secret) {
	var consumer_secret = "637d5f8e4e85425682cc7f04954b96fe";
	var parameters = 'oauth_consumer_key=' + oauth_consumer_key + '&oauth_nonce=' + oauth_nonce + '&oauth_signature_method=' + oauth_signature_method + '&oauth_timestamp=' + oauth_timestamp + '&oauth_token=' + oauth_token + '&oauth_version=' + oauth_version;
	var decodedParameters = escape(parameters);
	var decodedUrl = encodeURIComponent(url);
	var key = oauth_method + '&' + decodedUrl + '&' + decodedParameters;
	var signedwith = consumer_secret + '&' + oauth_token_secret;
	var hmac = crypto.createHmac("sha1", signedwith);
	var h = hmac.update(key);

	var oauth_signature = h.digest("base64");
	var encodedoauth_signature = encodeURIComponent(oauth_signature);
	return encodedoauth_signature;

}


/** 
 *create current timestamp
 * return timestamp in correct format
 */
var getTimestamp = function() {
	var timestamp = Date.now().toString();
	return timestamp.substr(0, 10);
}


/** 
 *create authorization header string from oauth parameters
 * return @string
 */
var getAuthorizationHeader = function(oauth_consumer_key, oauth_nonce, oauth_signature, oauth_signature_method, oauth_timestamp, oauth_token, oauth_version) {
	var authorization = 'OAuth oauth_consumer_key="' + oauth_consumer_key + '", oauth_nonce="' + oauth_nonce + '", oauth_signature="' + oauth_signature + '", oauth_signature_method="' + oauth_signature_method + '", oauth_timestamp="' + oauth_timestamp + '",oauth_token="' + oauth_token + '", oauth_version="' + oauth_version + '"';
	return authorization;
}



//exports

exports.getFitbitData = getFitbitData;