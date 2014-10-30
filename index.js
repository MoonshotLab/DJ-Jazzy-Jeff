var Bleacon = require('bleacon');
var Player = require('player');
var users = require('./users');
var thirtySeconds = 30000;


var handleBeaconDiscovery = function(beacon){
  var now = new Date().getTime();
  var user = findUserViaBeacon(beacon);

  if(user){
    console.log('...last talked to', user.name,
      (Math.round((now - user.lastConnected)/1000)), 'seconds ago');

    if(now - user.lastConnected > thirtySeconds)
      playSong(user.clip);

    user.lastConnected = now;
  }
};


var findUserViaBeacon = function(beacon){
  var match;

  users.forEach(function(user){
    if( user.uuid  == beacon.uuid &&
        user.major == beacon.major &&
        user.minor == beacon.minor) match = user;
  });

  return match;
};


var playSong = function(clipName) {
  var path = './clips/' + clipName + '.mp3';
  var player = new Player(path);

  player.play(function(err, player){
    if(err) console.log(err);
    else {
      console.log('--------------------');
      console.log('PLAYED SONG: ', clipName);
      console.log('--------------------');
    }
  });
};


users.forEach(function(user){
  user.lastConnected = new Date().getTime();
});


Bleacon.startScanning();
Bleacon.on('discover', handleBeaconDiscovery);
