#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CryptoHash.h"
#import "CryptoHash-umbrella.h"
#import "Pods-CryptoHash_Tests-umbrella.h"

FOUNDATION_EXPORT double tweakologyVersionNumber;
FOUNDATION_EXPORT const unsigned char tweakologyVersionString[];

