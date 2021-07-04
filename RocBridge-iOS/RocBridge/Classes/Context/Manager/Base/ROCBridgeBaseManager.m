//
//  ROCBridgeBaseManager.m
//  RocBridge
//
//  Created by RocYang on 2021/6/30.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import "ROCBridgeBaseManager.h"

@implementation ROCBridgeBaseManager

- (instancetype)initWithConfig:(ROCBridgeBaseManagerConfig *)baseManagerConfig
{
    return nil;
}

- (void)initManagerCompleted{
    
}

- (NSString *)managerName
{
    return nil;
}

- (void)throwException:(NSString *)exceptionInfo detailInfo:(NSString *)detailInfo
{
    
}

- (NSDictionary *)invokeMethod:(NSString *)methodName arguments:(NSArray *)arguments
{
    return nil;
}
 
- (void)injectionMethodImplementation:(NSString *)methodName methodImplementation:(ROCBridgeMethodImplementation)methodImplementation
{
    
}

- (id)getPropertyWithKey:(NSString *)key
{
    return nil;
}
@end
