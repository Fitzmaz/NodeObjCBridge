//
//  JOBridge+Echo.m
//  JavaScriptObjC
//
//  Created by zcr on 2020/7/27.
//  Copyright © 2020 zcr. All rights reserved.
//

#import "JOBridge+Echo.h"

@implementation JOBridge (Echo)

+ (void)jo_echo:(NSDictionary<JOAPIContextKey, id> *)context
{
    NSDictionary *data = context[JOAPIContextDataKey];
    JOAPICallback callback = context[JOAPIContextCallbackKey];
    callback(data);
}

@end
