var beaconProperties = {};

var onDeviceReady = function(){
  beaconProperties = {
    uuid        : device.uuid,
    identifier  : 'identifier',
    minor       : 1000,
    major       : 1000
  };

  var identifiersString = '';
  for(var key in beaconProperties){
    var partial = key + ':' + beaconProperties[key] + ' ';
    identifiersString += partial;
  }

  var mailLink = document.getElementById('emailButton');
  mailLink.href = [
    'mailto:joelongstreet@gmail.com?',
    'subject=DJ Jazzy Jeff',
    '&body=',
    identifiersString
  ].join('');
};


document.addEventListener('deviceready', onDeviceReady, false);
