//
//  UIViewController+Tweakology.m
//  tweakology
//
//  Created by Nikolay Ivanov on 10/15/18.
//

#import <Foundation/Foundation.h>
#import <tweakology/tweakology-Swift.h>
#import "UIViewController+Tweakology.h"
#import "SwizzlingClassProvider.h"


@implementation UIViewController (Tweakology)

+ (void)initialize {
    static dispatch_once_t once_token;
    dispatch_once(&once_token,  ^{
        SEL viewWDidLoadSelector = @selector(viewDidLoad);
        SEL viewDidLoadTweakologySelector = @selector(tweaked_viewDidLoad);
        Method originalMethod = class_getInstanceMethod(self, viewWDidLoadSelector);
        Method extendedMethod = class_getInstanceMethod(self, viewDidLoadTweakologySelector);
//        method_exchangeImplementations(originalMethod, extendedMethod);
    });
}

//- (void) tweaked_viewDidLoad {
//    [self tweaked_viewDidLoad];
//    if (@available(iOS 10.0, *)) {
//        NSDictionary *viewIndex = [self inspectLayout];
//        NSDictionary *tweaks = [TweaksStorage.sharedInstance getAllTweaks];
//        TweakologyLayoutEngine *engine = TweakologyLayoutEngine.sharedInstance;
//        [engine updateWithViewIndex:viewIndex];
//        for (id key in tweaks) {
//            NSArray *changeSeq = [tweaks objectForKey:key];
//            [engine tweakWithChangeSeq:changeSeq];
//        }
//    } else {
//        // Fallback on earlier versions
//    }
//}

@end
