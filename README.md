# DJ Jazzy Jeff
A mobile application which plays personalized theme music as a user enters a conference room.

The original reason for creating this project was to experiment with iBeacon technology. After initial testing, I quickly discovered iOS devices do not allow beacon broadcasting while in the background. The `CLLocationManager` had to be abandoned and a `CoreBluetooth` implementation was required. More discussion on the topic can be found at [this StackOverflow question](http://stackoverflow.com/questions/18944325/run-iphone-as-an-ibeacon-in-the-background). The code is heavily inspired from [Instrument's](http://www.instrument.com/) [Vicinity](https://github.com/Instrument/Vicinity) project.


## iOS Application(s)
A single iOS application serves as both the client and beacon manager, dependent on the device's orientation. Landscape mode triggers the song player and client manager, portrait acts as the song chooser and user.

There's not a whole lot of fancy going on here, to run the project you just need to clone the repo and install. If you're using a seperate web service, you'll want to change the `WEB_SERVICE_URL` config variable in the primary view controller.


## Web Server
The web server manages the song list, users, and provides restful services to access each. It's a node application and is currently deployed on heroku.
