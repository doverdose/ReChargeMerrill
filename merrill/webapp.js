#!/bin/node

var express = require('express'),
    fs = require('fs'),
    https = require('https'),
    http = require('http');

var app = express();

/*
app.use(function(req, res, next) {
		if(!req.secure) {
				return res.redirect('https://' + req.get('Host') + req.url);
		}
		next();
});



app.get('*', function(req, res) {
		if(!req.secure) {
				res.redirect('https://' + req.get('Host') + req.url);
		}
});

app.get('/', function(req, res) {
		res.send('Hello World');
});

var options = {
		key: fs.rea0dFileSync('secure/merrill.key'),
		cert: fs.readFileSync('secure/merrill.cert')
};

http.createServer().listen(8080);
console.log('HTTP server listening on 8080');
https.createServer(options, app).listen(3000);
console.log('HTTPS server listening on 3000');
*/

app.get('/', function(req, res) {
		res.send('Hello there');
});

app.listen(8080);
