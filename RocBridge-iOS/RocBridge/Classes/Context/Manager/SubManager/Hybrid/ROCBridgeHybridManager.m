//
//  ROCBridgeHybridManager.m
//  RocBridge
//
//  Created by RocYang on 2021/9/12.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import "ROCBridgeHybridManager.h"
#import "ROCBridgeHybridModuleData.h"
#import "ROCBridgeHybridAdditionInfo.h"

typedef void(^ROCBridgeHybridSyncCall)(void);
typedef void(^ROCBridgeHybridAsyncCall)(void);


#define SYCN_NORMAL_METHOD_TYPE(method, imp) \
ROCBridgeHybridResponse* (*method)(id, SEL, NSDictionary *) = (void *)imp;

#define SYCN_ADDITIONINFO_METHOD_TYPE(method, imp) \
ROCBridgeHybridResponse* (*method)(id, SEL, NSDictionary *, ROCBridgeHybridAdditionInfo *) = (void *)imp;

#define ASYCN_NORMAL_METHOD_TYPE(method, imp) \
void(*method)(id, SEL, NSDictionary *, ROCBridgeResponseCallback) = (void *)imp;

#define ASYCN_ADDITIONINFO_METHOD_TYPE(method, imp) \
void(*method)(id, SEL, NSDictionary *, ROCBridgeHybridAdditionInfo *, ROCBridgeResponseCallback) = (void *)imp;

@interface ROCBridgeHybridManager()
@property (nonatomic) ROCBridgeEventManager *eventManager;
@property (nonatomic) NSMutableDictionary *localHybridModuleDataDic;
@property (nonatomic) ROCBridgeHybridAdditionInfo *additionInfo;
@end

@implementation ROCBridgeHybridManager

- (void)initManagerCompleted
{
    self.localHybridModuleDataDic = [NSMutableDictionary new];
    
    __weak typeof(self) weakSelf = self;
    [self injectionMethodWithMethodName:@"invokeNativeAsyncMethod" implementation:^NSDictionary * _Nullable(NSDictionary * _Nonnull params) {
        NSDictionary *invokeInfo = params[@"invokeInfo"];
        NSDictionary *param = params[@"param"];
        [weakSelf invokeNativeAsyncMethod:invokeInfo param:param];
        return nil;
    }];
    
    [self injectionMethodWithMethodName:@"invokeNativeSyncMethod" implementation:^NSDictionary * _Nullable(NSDictionary * _Nonnull params) {
        NSDictionary *invokeInfo = params[@"invokeInfo"];
        NSDictionary *param = params[@"param"];
        return [weakSelf invokeNativeSyncMethod:invokeInfo param:param];
    }];
}

- (void)setUpManagerWith:(NSArray<ROCBridgeHybridRegister *> *)hybridRegisterArray
            eventManager:(ROCBridgeEventManager *)eventManager
             additionInfo:(ROCBridgeHybridAdditionInfo *)additionInfo {
    self.additionInfo = additionInfo;
    [self registerHybridWithHybridRegisterArray:hybridRegisterArray];
}

- (void)registerHybridWithHybridRegisterArray:(NSArray<ROCBridgeHybridRegister *> *)hybridRegisterArray
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
        for (NSString *methodName in moduleData.methodBook) {
            ROCBridgeHybridMethodData *methodData = [moduleData.methodBook objectForKey:methodName];
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

- (void)invokeNativeAsyncMethod:(NSDictionary *)invokeInfo param:(NSDictionary *)param
{
    NSString *moduleName = invokeInfo[@"moduleName"];
    NSString *methodName = invokeInfo[@"methodName"];
    
    ROCBridgeHybridModuleData *moduleData = [self.localHybridModuleDataDic objectForKey:moduleName];
    ROCBridgeHybridMethodData *methodData = [moduleData.methodBook objectForKey:methodName];
    
    ROCBridgeBaseHybridModule *moduleObj = [moduleData moduleObject];
    
    IMP methodImp = [methodData getMethodIMP];
    SEL methodSel = [methodData getMethodSEL];
    
    ROCBridgeHybridAsyncCall asyncCall = nil;
    
    __weak typeof(self) weakSelf = self;
    ROCBridgeResponseCallback responseCallback = ^(ROCBridgeHybridResponse *response){
        [weakSelf invokeNativeAsyncMethodCallback:response];
    };
    
    if (methodImp) {
        __weak typeof(moduleObj) weakModuleObj = moduleObj;
        __weak typeof(self.additionInfo) weakAdditionInfo = self.additionInfo;

        asyncCall = ^() {
            if (!weakModuleObj) {
                return ;
            }
            if (methodData.needAdditionInfo) {
                ASYCN_ADDITIONINFO_METHOD_TYPE(func, methodImp);
                func(weakModuleObj, methodSel, param, weakAdditionInfo, responseCallback);
            }else{
                ASYCN_NORMAL_METHOD_TYPE(func, methodImp)
                func(weakModuleObj, methodSel, param, responseCallback);
            }
        };
    }else{
        
        asyncCall = ^(){
            ROCBridgeHybridResponse *response = [ROCBridgeHybridResponse new];
            response.success = NO;
            response.code = ROCBridgeResponseMethodInexistence;
            response.data = @{};
            responseCallback(response);
        };
    }
    
    dispatch_queue_t queue = [moduleData moduleQueue];
    
    if (queue == nil) {
        ROCBridgeHybridResponse *response = [ROCBridgeHybridResponse new];
        response.success = NO;
        response.code = ROCBridgeResponseException;
        response.data = @{};
        responseCallback(response);
        return;
    }
    
    dispatch_async(queue, ^{
        asyncCall();
    });
}

- (ROCBridgeHybridResponse *)invokeNativeSyncMethod:(NSDictionary *)invokeInfo param:(NSDictionary *)param
{
    NSString *moduleName = invokeInfo[@"moduleName"];
    NSString *methodName = invokeInfo[@"methodName"];
    
    ROCBridgeHybridModuleData *moduleData = [self.localHybridModuleDataDic objectForKey:moduleName];
    ROCBridgeHybridMethodData *methodData = [moduleData.methodBook objectForKey:methodName];
    
    ROCBridgeBaseHybridModule *moduleObj = [moduleData moduleObject];
    
    IMP methodImp = [methodData getMethodIMP];
    SEL methodSel = [methodData getMethodSEL];
    
    __block ROCBridgeHybridResponse *response = [ROCBridgeHybridResponse new];
    ROCBridgeHybridSyncCall syncCall = nil;
    if (methodImp) {
        __weak typeof(moduleObj) weakModuleObj = moduleObj;
        __weak typeof(self.additionInfo) weakAdditionInfo = self.additionInfo;

        syncCall = ^() {
            if (!weakModuleObj) {
                return ;
            }
            if (methodData.needAdditionInfo) {
                SYCN_ADDITIONINFO_METHOD_TYPE(func, methodImp);
                response = func(weakModuleObj, methodSel, param, weakAdditionInfo);
            }else{
                SYCN_NORMAL_METHOD_TYPE(func, methodImp)
                response = func(weakModuleObj, methodSel, param);
            }
        };
    }else{
        response.success = NO;
        response.code = ROCBridgeResponseMethodInexistence;
        response.data = @{};
        syncCall = ^(){};
    }
    
    dispatch_queue_t queue = [moduleData moduleQueue];
    
    if (queue == nil || queue == dispatch_get_main_queue()) {
        NSAssert(NO, @"error");
        response.success = NO;
        response.code = ROCBridgeResponseException;
        response.data = @{};
        return response;
    }
    
    dispatch_sync(queue, ^{
        syncCall();
    });
    
    return response;
}

- (void)invokeNativeAsyncMethodCallback:(ROCBridgeHybridResponse *)response
{
    dispatch_async(self.bridgeQueue, ^{
        [self invokeMethodWithMethodName:@"invokeNativeAsyncMethodCallback" params:[response toDic]];
    });
}

- (NSString *)managerName
{
    return @"HybridManager";
}
@end
