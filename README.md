# TweakologyEngine

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

tweakology is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'TweakologyEngine'
```

If you experience issues with the `SDWebImage`,  `GCDWebServer` dependencies also add:

```ruby
pod 'SDWebImage', '4.4.2', :modular_headers => true
pod 'GCDWebServer', '3.4.2', :modular_headers => true
```

## Usage

### Swift

Import the TweakologyEngine module
```swift
import TweakologyEngine
```

Initialize the tweakology agent in your AppDelegate

```swift
var tweakologyAgent: TweakologyAgent?

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    ...
    tweakologyAgent = TweakologyAgent(name: "MyApp")
    tweakologyAgent?.start()
    ...
}
```

### ObjectiveC

Import the TweakologyEngine module
```objective-c
@import TweakologyEngine;
```

Initialize the tweakology agent in your AppDelegate

```objective-c
@implementation MyAppDelegate {
    TweakologyAgent *_agent;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
     ...
     _agent = [[TweakologyAgent alloc] initWithName:@"MyApp"];
    [_agent start];
    ...
}
```

## Author

Nikolay Ivanov, velikolay@gmail.com

## License

tweakology is available under the MIT license. See the LICENSE file for more info.
