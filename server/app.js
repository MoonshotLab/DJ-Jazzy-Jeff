var express = require('express');
var path = require('path');
var bodyParser = require('body-parser');
var users = require('./users');
var songs = require('./songs');
var app = express();

app.use(bodyParser.json());
app.use(bodyParser.urlencoded());


// Routes
app.get('/', function(req, res){
  res.send('sup?');
});

app.get('/songs', function(req, res){
  res.send(songs);
});

app.get('/users', function(req, res){
  res.send(users);
});

app.post('/user/create', function(req, res){
  console.log(req.body.username);
  res.send({ 'message' : 'User Created' });
});


// Error Handling
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

app.use(function(err, req, res, next) {
  res.status(err.status || 500);
  res.render('error', {
    message : err.message,
    error   : err
  });
});


// Start Server
app.set('port', process.env.PORT || 3000);
var server = app.listen(app.get('port'), function() {
  console.log('Express server listening on port ' + server.address().port);
});
