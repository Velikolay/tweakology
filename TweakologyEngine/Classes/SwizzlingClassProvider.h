//
//  SwizzlingClassProvider.h
//  tweakology
//
//  Created by Nikolay Ivanov on 10/15/18.
//

#ifndef SwizzlingClassProvider_h
#define SwizzlingClassProvider_h

#import <foundation/Foundation.h>

@interface SwizzlingClassProvider : NSObject {
    NSArray *viewControllerClasses;
}

@property (nonatomic, retain) NSArray *viewControllerClasses;

+ (id)sharedInstance;

@end

#endif /* SwizzlingClassProvider_h */
