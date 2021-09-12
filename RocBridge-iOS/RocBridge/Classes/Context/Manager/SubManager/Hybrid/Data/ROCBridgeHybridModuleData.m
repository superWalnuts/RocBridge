//
//  ROCBridgeHybridModuleData.m
//  RocBridge
//
//  Created by RocYang on 2021/9/12.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import "ROCBridgeHybridModuleData.h"

@interface ROCBridgeHybridRegister()
@property (nonatomic) ROCBridgeHybridRegister *hybridRegister;
@property (nonatomic) ROCBridgeEventManager *eventManager;
@end

@implementation ROCBridgeHybridModuleData

- (instancetype)initWithHybridRegister:(ROCBridgeHybridRegister *)hybridRegister eventManager:(ROCBridgeEventManager *)eventManager {
    self = [super init];
    if (self) {
        _hybridRegister = hybridRegister;
        _eventManager = eventManager;
        [self setUpModuleData];
    }
    return self;
}

- (void)setUpModuleData
{
    
}
@end
