//
//  CryptoHash.m
//  CryptoHash
//
//  Created by Nikolay Ivanov on 7/4/18.
//

#import <Foundation/Foundation.h>

#import "CryptoHash.h"

#import <CommonCrypto/CommonCrypto.h>

@implementation CryptoHash

+ (NSString *)sha1:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

@end
