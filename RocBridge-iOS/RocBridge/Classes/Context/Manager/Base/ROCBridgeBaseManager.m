//
//  ROCBridgeBaseManager.m
//  RocBridge
//
//  Created by RocYang on 2021/6/30.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import "ROCBridgeBaseManager.h"
@interface ROCBridgeBaseManager()
@property (nonatomic) ROCBridgeBaseManagerConfig *baseManagerConfig;
@end

@implementation ROCBridgeBaseManager

- (instancetype)initWithConfig:(ROCBridgeBaseManagerConfig *)baseManagerConfig
{
    self = [super init];
    if (self) {
        _baseManagerConfig = baseManagerConfig;
        [self initManagerCompleted];
    }
    return self;
}

- (void)initManagerCompleted
{
    
}

- (NSString *)managerName
{
    return @"";
}

- (void)throwException:(NSString *)exceptionInfo detailInfo:(NSString *)detailInfo
{
    if (self.baseManagerConfig.exceptionHandler) {
        self.baseManagerConfig.exceptionHandler(exceptionInfo, detailInfo);
    }
}

- (NSDictionary *)invokeMethodWithMethodName:(NSString *)methodName
                                      params:(NSDictionary *)params
{
    if (self.baseManagerConfig.contextCore) {
        return [self.baseManagerConfig.contextCore invokeJSMethodWithManagerName:[self managerName] methodName:methodName params:params];
    }
    
    return nil;
}
 
- (void)injectionMethodWithMethodName:(NSString *)methodName
                       implementation:(ROCBridgeMethodImplementation)implementation
{
    if (self.baseManagerConfig.contextCore) {
        [self.baseManagerConfig.contextCore injectionMethodWithManagerName:[self managerName] methodName:methodName implementation:implementation];
    }
}

@end
