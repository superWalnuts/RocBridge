//
//  ROCBridgeHybridModuleData.h
//  RocBridge
//
//  Created by RocYang on 2021/9/12.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROCBridgeHybridRegister.h"
#import "ROCBridgeEventManager.h"
#import "ROCBridgeHybridMethodData.h"
NS_ASSUME_NONNULL_BEGIN

@interface ROCBridgeHybridModuleData : NSObject

@property (nonatomic, readonly) NSString *moduleName;
@property (nonatomic, readonly) NSDictionary<NSString *, ROCBridgeHybridMethodData *> *methodBook;

- (instancetype)initWithHybridRegister:(ROCBridgeHybridRegister *)hybridRegister eventManager:(ROCBridgeEventManager *)eventManager;

- (ROCBridgeBaseHybridModule *)moduleObject;

- (dispatch_queue_t)moduleQueue;

@end

NS_ASSUME_NONNULL_END
