//
//  ROCBridgeJSInterfaceManager.m
//  RocBridge
//
//  Created by RocYang on 2021/10/16.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import "ROCBridgeJSInterfaceManager.h"
@interface ROCBridgeJSInterfaceManager()
@property (nonatomic) NSMutableDictionary *jsInterfaceDic;
@property (nonatomic) NSMutableDictionary *interfaceCallbackDic;
@property (nonatomic) NSInteger callId;
@end

@implementation ROCBridgeJSInterfaceManager

- (void)initManagerCompleted
{
    self.callId = 0;
    self.jsInterfaceDic = [NSMutableDictionary new];
    self.interfaceCallbackDic = [NSMutableDictionary new];
    
    __weak typeof(self) weakSelf = self;
    [self injectionMethodWithMethodName:@"registerInterfaceToNative" implementation:^NSDictionary * _Nullable(NSDictionary * _Nonnull params) {
        [weakSelf registerInterfaceToNative:params];
        return nil;
    }];
    
    __weak typeof(self) weakSelf = self;
    [self injectionMethodWithMethodName:@"invokeAsyncInterfaceCallback" implementation:^NSDictionary * _Nullable(NSDictionary * _Nonnull params) {
        [weakSelf registerInterfaceToNative:params];
        return nil;
    }];
}

- (BOOL)registerInterfaceToNative:(NSDictionary *)params
{
    NSString *className = params[@"className"];
    NSString *interfaceName = params[@"interfaceName"];
    BOOL isSync = [params[@"isSync"] boolValue];
    
    if (className.length == 0 || interfaceName.length == 0) {
          return NO;
    }
    
    NSMutableDictionary *classInfoDic = [self.jsInterfaceDic objectForKey:className];
    if (!classInfoDic) {
        classInfoDic = [NSMutableDictionary new];
        [self.jsInterfaceDic setObject:classInfoDic forKey:className];
    }
    
    [classInfoDic setObject:params forKey:interfaceName];
}

- (void)invokeJSAsyncInterface:(ROCBridgeJSInterfaceRequest *)interfaceRequest
{
    if (interfaceRequest.className.length == 0 || interfaceRequest.interfaceName.length == 0) {
        return;
    }
    NSInteger callId = [self getCallId];
    
    if (interfaceRequest.responseCallback) {
        [self.interfaceCallbackDic setObject:@(callId) forKey:interfaceRequest.responseCallback];
    }
    
    NSDictionary *invokeInfo = @{@"className": interfaceRequest.className, @"interfaceName": interfaceRequest.interfaceName, @"sync": @(NO), @"callId":@(callId)};
    NSDictionary *param = interfaceRequest.param;
    [self invokeMethodWithMethodName:@"invokeInterface" params:@{@"invokeInfo": invokeInfo, @"param": param?:@{}}];
}

- (void)invokeAsyncInterfaceCallback:(NSDictionary *)params
{
    NSDictionary *invokeInfo = params[@"invokeInfo"];
    NSDictionary *responseDic = params[@"response"];
    
    ROCBridgeHybridResponse *response = [ROCBridgeHybridResponse new];
    [response setUpWithDic:responseDic];
    
    NSInteger callId = [invokeInfo[@"callId"] integerValue];
    
    ROCBridgeResponseCallback responseCallback = [self.interfaceCallbackDic objectForKey:@(callId)];
    if (!responseCallback) {
        return;
    }
    responseCallback(response);
}

- (NSInteger)getCallId
{
    return ++self.callId;
}

- (NSString *)managerName
{
    return @"JSIntefaceManager";
}


@end
