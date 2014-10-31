var beaconProperties = {};


var updateStatus = function(text){
  var statusText = document.getElementById('status');
  statusText.innerHTML = text;
};


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
      val = beaconProperties[key].replace(/-/g, '').toLowerCase();
    var partial = [key, ':', val, ' '].join('');

    identifiersString += partial;
  }

  var mailLink = document.getElementById('emailButton');
  mailLink.href = [
    'mailto:joelongstreet@gmail.com?',
    'subject=DJ Jazzy Jeff',
    '&body=',
    identifiersString
  ].join('');

  var beaconRegion = new cordova.plugins.locationManager.BeaconRegion(
    beaconProperties.identifier,
    beaconProperties.uuid,
    beaconProperties.major,
    beaconProperties.minor
  );

  cordova.plugins.locationManager.requestAlwaysAuthorization();
  cordova.plugins.locationManager.isAdvertisingAvailable()
    .then(function(isSupported){
      if(isSupported){
        cordova.plugins.locationManager.startAdvertising(beaconRegion)
          .fail(updateStatus)
          .done(function(){ updateStatus('currently broadcasting location...'); });
      } else
        updateStatus('Beacon advertising not supported :(');
    })
    .fail(updateStatus);
};


document.addEventListener('deviceready', onDeviceReady, false);
