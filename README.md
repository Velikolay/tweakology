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

Initializing the TweakologyAgent in your ideally in your the app's main function will allow you apply existing tweak configurations as well as creating new tweaks with the help of the Tweakology App. For production usecases only initialize the TweakologyEngine and keep the TweakologyAgent disabled.

### Swift

```swift
import TweakologyEngine

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var tweakologyAgent: TweakologyAgent?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    ...
    tweakologyAgent = TweakologyAgent(name: "MyApp")
    tweakologyAgent?.start()
    ...
  }
}
```

### ObjectiveC

```objective-c
@import TweakologyEngine;

int main(int argc, char * argv[])
{
    @autoreleasepool {
        TweakologyAgent *agent = [[TweakologyAgent alloc] initWithName:@"MyApp"];
        [agent start];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([MyAppDelegate class]));
    }
}
```

## Author

Nikolay Ivanov, velikolay@gmail.com

## License

tweakology is available under the MIT license. See the LICENSE file for more info.
