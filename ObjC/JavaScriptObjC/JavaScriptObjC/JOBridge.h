//
//  JOBridge.h
//  JavaScriptObjC
//
//  Created by zcr on 2020/7/27.
//  Copyright © 2020 hundsun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JOAPICallback)(NSDictionary *responseData);

typedef NSString * JOAPIContextKey NS_STRING_ENUM;
extern JOAPIContextKey const JOAPIContextDataKey;
extern JOAPIContextKey const JOAPIContextCallbackKey; // JOAPICallback

@interface JOBridge : NSObject

@end

NS_ASSUME_NONNULL_END
