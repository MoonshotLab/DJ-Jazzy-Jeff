var Bleacon = require('bleacon');
var Player = require('player');
var users = require('./users');


var handleBeaconDiscovery = function(beacon){
  var user = findUserViaBeacon(beacon);

  if(user){
    if(beacon.proximity == 'near' && user.lastState != 'near')
      playSong(user.clip);

    user.lastState = beacon.proximity;
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
    else console.log('played', clipName);
  });
};


Bleacon.startScanning();
Bleacon.on('discover', handleBeaconDiscovery);
