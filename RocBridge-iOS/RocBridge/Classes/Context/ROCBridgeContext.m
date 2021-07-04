//
//  ROCBridgeContext.m
//  RocBridge
//
//  Created by RocYang on 2021/6/24.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import "ROCBridgeContext.h"

@interface ROCBridgeContext()
@property (nonatomic) NSString *jsString;
@property (nonatomic) ROCBridgeConfig *contextConfig;
@property (nonatomic) ROCBridgeHandler *contextHandler;
@property (nonatomic) dispatch_queue_t bridgeQueue;
@end

@implementation ROCBridgeContext


- (instancetype)initContextWithJSString:(NSString *)jsString
                          contextConfig:(ROCBridgeConfig *)contextConfig
                         contextHandler:(ROCBridgeHandler *)contextHandler
{
    self = [super init];
    if (self) {
        _jsString = jsString;
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
