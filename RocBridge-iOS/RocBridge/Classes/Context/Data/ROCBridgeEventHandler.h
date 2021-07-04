//
//  ROCBridgeEventHandler.h
//  RocBridge
//
//  Created by RocYang on 2021/7/1.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROCBridgeHybridResponse.h"
NS_ASSUME_NONNULL_BEGIN

@interface ROCBridgeEventHandler : NSObject
@property (nonatomic) NSString *eventName;
@property (nonatomic) ROCBridgeResponseCallback callback;
@end

NS_ASSUME_NONNULL_END
