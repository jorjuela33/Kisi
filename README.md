
# Kisi

In order to run the project is necessary to intall the required pods. For testing purposes I downloaded the [beacon simulator app](https://itunes.apple.com/us/app/beacon-simulator/id1098267039?mt=8).

# App Architecture
The app is built using the VIPER architecture. VIPER is an application of Clean Architecture that has been used to build many large projects. Clean Architecture divides an app’s logical structure into distinct layers of responsibility. This makes it easier to isolate dependencies and to test the interactions at the boundaries between layers. This architecture is combined with the powerful Operation and OperationQueue classes. I like to wrap the Network requests inside a Operation because this provide the facility to add dependencies between them, to add conditions, isolate the code and react to network changes based on operations priorities. There is no framework for requests such alamofire (I can use alamofire if that is a requirement) because in most of the apps the request are simply sending data and downloading data, sometimes including all the boilerplate code provided by a framework is not necessary, this is exposed by marcus zarra in this talk https://academy.realm.io/posts/slug-marcus-zarra-exploring-mvcn-swift/

# Features
Is a simple app that allows to monitoring beacons in a certain range. I didn't wanted to go deeper into implementations so the current behavior is to monitor beacons in a range with accuracy lesser than 50. When a beacon is found the app displays a modal screen and perform a request to unlock the device, if the result of the API call is a success then the unlock animation is diplayed. The unlock animation is just a naive implementation for this purpose.

- Request local notification permission
- Request location access permission
- Displays a local notification if the unlocking is in background
- Presents a modal screen every time the user goes to background except if the user minimize the app while is sending a request to unlock a device.
- Basic unit testing
- Profile screen

In a production app there are some considerations to keep in mind, the iOS devices allows to monitor a maximun of 20 regions, I think this could be improved representing the beacon network as a graph or tree. Another considerations to keep in mind is the high battery consume if the user is ranging for beacons all the time, so it's important to define a logic here, something like stopping the ranging monitoring when the user lefts the beacon region and using wake up calls produced by the didEnterRegion delegate.
