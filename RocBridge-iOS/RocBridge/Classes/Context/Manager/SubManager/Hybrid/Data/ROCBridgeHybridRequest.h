//
//  ROCBridgeHybridRequest.h
//  RocBridge
//
//  Created by RocYang on 2021/7/4.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROCBridgeHybridResponse.h"
NS_ASSUME_NONNULL_BEGIN

@interface ROCBridgeHybridRequest : NSObject

@property (nonatomic) NSString *moduleName;
@property (nonatomic) NSString *methodName;
@property (nonatomic) NSDictionary *param;
@property (nonatomic) ROCBridgeResponseCallback responseCallback;

@end

NS_ASSUME_NONNULL_END
