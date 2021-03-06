//
//  ROCBridgeHybridMethodData.h
//  RocBridge
//
//  Created by RocYang on 2021/9/12.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROCBridgeHybridRegister.h"

NS_ASSUME_NONNULL_BEGIN

@interface ROCBridgeHybridMethodData : NSObject

- (instancetype)initWithMethodInfo:(NSDictionary *)methodInfo hybridRegister:(ROCBridgeHybridRegister *)hybridRegister;

@property(nonatomic, readonly) NSString *originalMethodName;
@property(nonatomic, readonly) NSString *hybridMethodName;
@property(nonatomic, readonly) BOOL isSync;
@property(nonatomic, readonly) BOOL needAdditionInfo;


- (NSDictionary *)coreInfo;

- (IMP)getMethodIMP;
- (SEL)getMethodSEL;



@end

NS_ASSUME_NONNULL_END
