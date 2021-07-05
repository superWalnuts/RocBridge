//
//  ROCBridgeBaseManager.h
//  RocBridge
//
//  Created by RocYang on 2021/6/30.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROCBridgeHandler.h"
#import "ROCBridgeContextCoreProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface ROCBridgeBaseManagerConfig : NSObject

@property (nonatomic) dispatch_queue_t bridgeQueue;

@property (nonatomic) ROCExceptionHandler exceptionHandler;

@property (nonatomic) id<ROCBridgeContextCoreProtocol> contextCore;

@end


@interface ROCBridgeBaseManager : NSObject

@property (nonatomic, readonly) dispatch_queue_t bridgeQueue;

- (instancetype)initWithConfig:(ROCBridgeBaseManagerConfig *)baseManagerConfig;

- (void)initManagerCompleted;

- (NSString *)managerName;

- (void)throwException:(NSString *)exceptionInfo detailInfo:(NSString *)detailInfo;

- (NSDictionary *)invokeMethodWithMethodName:(NSString *)methodName arguments:(NSArray *)arguments;
 
- (void)injectionMethodWithMethodName:(NSString *)methodName implementation:(ROCBridgeMethodImplementation)implementation;

@end

NS_ASSUME_NONNULL_END
