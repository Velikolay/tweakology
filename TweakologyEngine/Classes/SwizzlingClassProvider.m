//
//  SwizzlingClassProvider.m
//  tweakology
//
//  Created by Nikolay Ivanov on 10/15/18.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "SwizzlingClassProvider.h"

@implementation SwizzlingClassProvider

@synthesize viewControllerClasses;

#pragma mark Singleton Methods

+ (id)sharedInstance {
    static SwizzlingClassProvider *sharedProvider = nil;
    static dispatch_once_t onceToken1;
    dispatch_once(&onceToken1, ^{
        sharedProvider = [[self alloc] init];
    });
    return sharedProvider;
}

- (id)init {
    if (self = [super init]) {
        viewControllerClasses = view_controller_classes();
    }
    return self;
}

NSArray *get_subclasses(Class *classes, int numClasses, Class parentClass)
{
    NSMutableArray *result = [NSMutableArray array];
    for (NSUInteger i = 0; i < numClasses; i++)
    {
        Class superClass = classes[i];
        do
        {
            superClass = class_getSuperclass(superClass);
        } while(superClass && superClass != parentClass);
        
        if (superClass == nil)
        {
            continue;
        }
        
        [result addObject:classes[i]];
    }
    return result;
}

NSArray *get_main_bundle_classes(NSArray *classes)
{
    NSMutableArray *result = [NSMutableArray array];
    for (NSUInteger i = 0; i < classes.count; i++) {
        Class c = classes[i];
        NSBundle *b = [NSBundle bundleForClass:c];
        if (b == [NSBundle mainBundle]) {
            NSLog(@"%s", class_getName(c));
            [result addObject:classes[i]];
        }
    }
    return result;
}

NSArray *view_controller_classes()
{
    int numClasses;
    Class *classes = NULL;
    
    classes = NULL;
    numClasses = objc_getClassList(NULL, 0);
    NSArray *classesToSwizzle = NULL;
    if (numClasses > 0 )
    {
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        NSArray *subclasses = get_subclasses(classes, numClasses, [UIViewController class]);
        classesToSwizzle = get_main_bundle_classes(subclasses);
        free(classes);
    }
    return classesToSwizzle;
}

@end
