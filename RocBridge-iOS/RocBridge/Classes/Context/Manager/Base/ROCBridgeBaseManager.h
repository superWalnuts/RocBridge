//
//  ROCBridgeBaseManager.h
//  RocBridge
//
//  Created by RocYang on 2021/6/30.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROCBridgeHandler.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSDictionary *_Nullable(^ROCBridgeMethodImplementation)(NSDictionary *invokeInfo, NSDictionary *data);

@interface ROCBridgeBaseManagerConfig : NSObject

@property (nonatomic) dispatch_queue_t bridgeQueue;

@property (nonatomic) ROCExceptionHandler exceptionHandler;

@property (nonatomic) id contextCore;

@end


@interface ROCBridgeBaseManager : NSObject

@property (nonatomic, readonly) dispatch_queue_t bridgeQueue;

- (instancetype)initWithConfig:(ROCBridgeBaseManagerConfig *)baseManagerConfig;

- (void)initManagerCompleted;

- (NSString *)managerName;

- (void)throwException:(NSString *)exceptionInfo detailInfo:(NSString *)detailInfo;

- (NSDictionary *)invokeMethod:(NSString *)methodName arguments:(NSArray *)arguments;
 
- (void)injectionMethodImplementation:(NSString *)methodName methodImplementation:(ROCBridgeMethodImplementation)methodImplementation;

- (id)getPropertyWithKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
