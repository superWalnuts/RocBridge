//
//  ROCBridgeContext.m
//  RocBridge
//
//  Created by RocYang on 2021/6/24.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import "ROCBridgeContext.h"
#import "ROCBridgeContextCoreProtocol.h"
#import "ROCBridgeJSContextCore.h"

#import "ROCBridgeHybridManager.h"
#import "ROCBridgeEventManager.h"

@interface ROCBridgeContext()
@property (nonatomic) id<ROCBridgeContextCoreProtocol> contextCore;
@property (nonatomic) ROCBridgeConfig *contextConfig;
@property (nonatomic) ROCBridgeHandler *contextHandler;
@property (nonatomic) dispatch_queue_t bridgeQueue;

@property (nonatomic) ROCBridgeHybridManager *bridgeHybridManager;
@property (nonatomic) ROCBridgeEventManager *bridgeEventManager;

@end

@implementation ROCBridgeContext


- (instancetype)initContextWithJSString:(NSString *)jsString
                          contextConfig:(ROCBridgeConfig *)contextConfig
                         contextHandler:(ROCBridgeHandler *)contextHandler
{
    self = [super init];
    if (self) {
        _contextCore = [[ROCBridgeJSContextCore alloc] initContextCoreWithJSString:jsString contextConfig:contextConfig contextHandler:contextHandler];
        _contextConfig = contextConfig;
        _contextHandler = contextHandler;
        [self startInitContext];
    }
    return self;
}


- (instancetype)initContextWithWebView:(WKWebView *)webView
                                   url:(NSString *)url
                         contextConfig:(ROCBridgeConfig *)contextConfig
                        contextHandler:(ROCBridgeHandler *)contextHandler
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)startInitContext
{
    NSString *contextName = self.contextConfig.name;
    NSString *queueName = [NSString stringWithFormat:@"rocbBridge.%@.bridgequeue",(contextName.length > 0)?contextName:@"default"];
    self.bridgeQueue = dispatch_queue_create([queueName UTF8String], DISPATCH_QUEUE_SERIAL);
}

- (void)startInitManager
{
    ROCBridgeBaseManagerConfig *managerConfig = [ROCBridgeBaseManagerConfig new];
    managerConfig.bridgeQueue = self.bridgeQueue;
    managerConfig.contextCore = self.contextCore;
    managerConfig.exceptionHandler = self.contextHandler.exceptionHandler;
    
    self.bridgeEventManager = [[ROCBridgeEventManager alloc] initWithConfig:managerConfig];
    
    self.bridgeHybridManager = [[ROCBridgeHybridManager alloc] initWithConfig:managerConfig];
    [self.bridgeHybridManager setUpManagerWith:nil eventManager:self.bridgeEventManager addtionInfo:nil];
    
}


- (void)invokeJSAsyncMethod:(ROCBridgeHybridRequest *)request
{
    
}


- (void)registerEventHandler:(ROCBridgeEventHandler *)eventHandler
{
    
}



- (void)unRegisterEventHandler:(ROCBridgeEventHandler *)eventHandler
{
    
}

@end
