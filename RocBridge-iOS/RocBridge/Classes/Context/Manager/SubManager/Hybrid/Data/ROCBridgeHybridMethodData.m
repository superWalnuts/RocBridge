//
//  ROCBridgeHybridMethodData.m
//  RocBridge
//
//  Created by RocYang on 2021/9/12.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import "ROCBridgeHybridMethodData.h"

@implementation ROCBridgeHybridMethodData

- (instancetype)initWithMethodInfo:(NSDictionary *)methodInfo hybridRegister:(ROCBridgeHybridRegister *)hybridRegister
{
    self = [super init];
    if (self) {
           
    }
    return self;
}

- (NSDictionary *)coreInfo
{
    return @{@"isSync": @(self.isSync)};
}
@end
