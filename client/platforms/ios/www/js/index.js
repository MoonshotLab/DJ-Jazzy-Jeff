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
    var val = beaconProperties[key];
    if(key == 'uuid')
      val = beaconProperties[key].replace('-', '').toLowerCase();
    var partial = [key, ':', val, ' '].join();

    identifiersString += partial;
  }

  var mailLink = document.getElementById('emailButton');
  mailLink.href = [
    'mailto:joelongstreet@gmail.com?',
    'subject=DJ Jazzy Jeff',
    '&body=',
    identifiersString
  ].join('');

  cordova.plugins.locationManager.requestAlwaysAuthorization();

  var beaconRegion = new cordova.plugins.locationManager.BeaconRegion(
    beaconProperties.identifier,
    beaconProperties.uuid,
    beaconProperties.major,
    beaconProperties.minor
  );

  cordova.plugins.locationManager.startAdvertising(beaconRegion);
};


document.addEventListener('deviceready', onDeviceReady, false);
