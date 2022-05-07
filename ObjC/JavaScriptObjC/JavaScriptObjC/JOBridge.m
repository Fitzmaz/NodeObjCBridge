//
//  JOBridge.m
//  JavaScriptObjC
//
//  Created by zcr on 2020/7/27.
//  Copyright © 2020 zcr. All rights reserved.
//

#import "JOBridge.h"

JOAPIContextKey const JOAPIContextDataKey = @"JOAPIContextData";
JOAPIContextKey const JOAPIContextCallbackKey = @"JOAPIContextCallback";

static NSString * const JOBridgeMessageNameKey = @"name";
static NSString * const JOBridgeMessageDataKey = @"data";
static NSString * const JOBridgeMessageIdentifierKey = @"id";
static NSString * const JOActionPrefix = @"jo_";

@protocol JOBridgeCallback <NSObject>

- (void)response:(NSString *)response;

@end

@implementation JOBridge

+ (void)postMessage:(NSString *)message callback:(id<JOBridgeCallback>)callback
{
    NSData *msgData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *msgObj = [NSJSONSerialization JSONObjectWithData:msgData options:0 error:nil];
    NSString *messageName = msgObj[JOBridgeMessageNameKey];
    NSDictionary *messageData = msgObj[JOBridgeMessageDataKey];
    NSString *messageIdentifier = msgObj[JOBridgeMessageIdentifierKey];
    
    [self performAction:messageName withData:messageData completion:^(NSDictionary *responseData){
        NSDictionary *responseObj = @{
            JOBridgeMessageNameKey: messageName,
            JOBridgeMessageDataKey: responseData,
            JOBridgeMessageIdentifierKey: messageIdentifier
        };
        NSData *resData = [NSJSONSerialization dataWithJSONObject:responseObj options:0 error:nil];
        NSString *resStr = [[NSString alloc] initWithData:resData encoding:NSUTF8StringEncoding];
        [callback response:resStr];
    }];
}

+ (void)performAction:(NSString *)name withData:(NSDictionary *)data completion:(JOAPICallback)completion
{
    SEL actionSel = NSSelectorFromString([NSString stringWithFormat:@"%@%@:", JOActionPrefix, name]);
    if (![self respondsToSelector:actionSel]) {
        completion(@{@"error": @"unrecognized method"});
        return;
    }
    NSDictionary *context = @{
        JOAPIContextDataKey: data,
        JOAPIContextCallbackKey: completion
    };
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:actionSel withObject:context];
    #pragma clang diagnostic pop
}

@end
