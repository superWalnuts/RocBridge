//
//  ROCBridgeHybridManager.m
//  RocBridge
//
//  Created by RocYang on 2021/9/12.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import "ROCBridgeHybridManager.h"
#import "ROCBridgeHybridModuleData.h"

@interface ROCBridgeHybridManager()
@property (nonatomic) ROCBridgeEventManager *eventManager;
@property (nonatomic) NSMutableDictionary *localHybridModuleDataDic;
@end

@implementation ROCBridgeHybridManager

- (void)initManagerCompleted
{
    self.localHybridModuleDataDic = [NSMutableDictionary new];
}

- (void)setUpManagerWith:(NSArray<ROCBridgeHybridRegister *> *)hybridRegisterArray
            eventManager:(ROCBridgeEventManager *)eventManager
             addtionInfo:(ROCBridgeHybridAdditionInfo *)addtionInfo {
    [self registerHybridWith:hybridRegisterArray];
}

- (void)registerHybridWith:(NSArray<ROCBridgeHybridRegister *> *)hybridRegisterArray
{
    NSMutableDictionary *hybridRegisterInfoDic = [NSMutableDictionary new];
    
    for (ROCBridgeHybridRegister *hybridRegister in hybridRegisterArray) {
        Class moduleClass = hybridRegister.moduleClass;
        if (!moduleClass && hybridRegister.moduleInstance) {
            moduleClass = hybridRegister.moduleInstance.class;
        }
        
        ROCBridgeHybridModuleData *moduleData = [[ROCBridgeHybridModuleData alloc] initWithHybridRegister:hybridRegister eventManager:self.eventManager];
        
        [self.localHybridModuleDataDic setObject:moduleData forKey:moduleData.moduleName];
        
        NSMutableDictionary *moduleCoreDic = [NSMutableDictionary new];
        for (NSString *methodName in moduleData.methodDataDic) {
            ROCBridgeHybridMethodData *methodData = [moduleData.methodDataDic objectForKey:methodName];
            [moduleCoreDic setObject:[methodData coreInfo] forKey:methodName];
        }
        
        if ([hybridRegisterInfoDic objectForKey:moduleData.moduleName]) {
            NSString *message = [NSString stringWithFormat:@"Hybrid duplicate registration! moduleName->%@", moduleData.moduleName];
            [self throwException:@"Hybrid duplicate registration!" detailInfo:message];
            continue;
        }
        
        [hybridRegisterInfoDic setObject:moduleCoreDic forKey:moduleData.moduleName];
    }
    
    [self invokeMethodWithMethodName:@"registerHybrid" params:@{@"hybridRegisterInfoDic": hybridRegisterInfoDic}];
}

- (NSString *)managerName
{
    return @"HybridManager";
}
@end
