//
//  ROCBridgeContext.h
//  RocBridge
//
//  Created by RocYang on 2021/6/24.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import "ROCBridgeConfig.h"
#import "ROCBridgeHandler.h"
#import "ROCBridgeHybridRequest.h"
#import "ROCBridgeEventHandler.h"
#import <WebKit/WKWebView.h>
NS_ASSUME_NONNULL_BEGIN

@interface ROCBridgeContext : NSObject


/// Initialize the context using a string, You can also set the configuration and handler at this time.
/// @param jsString This is the string of a JS file.
/// @param contextConfig You can set the context name, hybridModule, etc.
/// @param contextHandler Here you can set the context's exception handler.

- (instancetype)initContextWithJSString:(NSString *)jsString
                          contextConfig:(ROCBridgeConfig *)contextConfig
                         contextHandler:(ROCBridgeHandler *)contextHandler NS_DESIGNATED_INITIALIZER;


- (instancetype)initContextWithWebView:(WKWebView *)webView
                                   url:(NSString *)url
                         contextConfig:(ROCBridgeConfig *)contextConfig
                        contextHandler:(ROCBridgeHandler *)contextHandler NS_DESIGNATED_INITIALIZER;


- (instancetype)init NS_UNAVAILABLE;

/// Invokes an asynchronous method in the JS context.
/// @param hybridRequest Request info.
- (void)invokeJSAsyncMethod:(ROCBridgeHybridRequest *)hybridRequest;


- (void)registerEventHandler:(ROCBridgeEventHandler *)eventHandler;


- (void)unRegisterEventHandler:(ROCBridgeEventHandler *)eventHandler;


@end

NS_ASSUME_NONNULL_END
