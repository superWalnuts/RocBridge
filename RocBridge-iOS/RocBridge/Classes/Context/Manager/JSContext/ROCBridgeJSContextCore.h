//
//  ROCBridgeJSContextCore.h
//  RocBridge
//
//  Created by RocYang on 2021/7/5.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROCBridgeContextCoreProtocol.h"
#import "ROCBridgeConfig.h"
#import "ROCBridgeHandler.h"
NS_ASSUME_NONNULL_BEGIN

@interface ROCBridgeJSContextCore : NSObject<ROCBridgeContextCoreProtocol>

- (instancetype)initContextCoreWithJSString:(NSString *)jsString
                              contextConfig:(ROCBridgeConfig *)contextConfig
                             contextHandler:(ROCBridgeHandler *)contextHandler;
@end

NS_ASSUME_NONNULL_END
