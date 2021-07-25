//
//  ROCBridgeJSContextCore.m
//  RocBridge
//
//  Created by RocYang on 2021/7/5.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import "ROCBridgeJSContextCore.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface ROCBridgeJSContextCore()
@property (nonatomic) NSString *jsString;
@property (nonatomic) ROCBridgeConfig *contextConfig;
@property (nonatomic) ROCBridgeHandler *contextHandler;

@property (nonatomic) JSContext *jsContext;

@end

@implementation ROCBridgeJSContextCore

- (instancetype)initContextCoreWithJSString:(NSString *)jsString
                              contextConfig:(ROCBridgeConfig *)contextConfig
                             contextHandler:(ROCBridgeHandler *)contextHandler
{
    self = [super init];
    if (self) {
        _jsString = jsString;
        _contextConfig = contextConfig;
        _contextHandler = contextHandler;
        [self initContextCore];
    }
    return self;
}

- (void)initContextCore
{
    JSVirtualMachine *jsVirtualMachine = nil;
    
    if (self.contextConfig.jsVirtualMachine) {
        jsVirtualMachine = self.contextConfig.jsVirtualMachine;
    }else{
        jsVirtualMachine = [JSVirtualMachine new];
    }
    
    self.jsContext = [[JSContext alloc] initWithVirtualMachine:jsVirtualMachine];
    
    [self.jsContext setName:[NSString stringWithFormat:@"RocBridge_%@", self.contextConfig.name?:@"default"]];
    
    [self updateExceptionHandler];
    
    [self evaluateScript];
        
}

- (void)evaluateScript
{
    [self.jsContext evaluateScript:@"var window = {}"];

    [self.jsContext evaluateScript:self.jsString];
    JSValue *window = self.jsContext[@"window"];
    JSValue *rocBridgeContext = window[@"rocBridgeContext"];
    JSValue *test = rocBridgeContext[@"test"];
    NSString *str = [test toString];
    
}

- (void)updateExceptionHandler
{
    __weak typeof(self) weakSelf = self;
    [self.jsContext setExceptionHandler:^(JSContext *context, JSValue *exception) {
        __strong typeof(weakSelf) self = weakSelf;
        NSString *info = [exception toString];
        NSString *exceptionDetail = @"";
        NSString *stackInfo = [[exception objectForKeyedSubscript:@"stack"] toString];
        NSString *lineNumberInfo = [[exception objectForKeyedSubscript:@"line"] toString];
        NSString *columnNumberInfo = [[exception objectForKeyedSubscript:@"column"] toString];
        if (info && stackInfo && lineNumberInfo && columnNumberInfo) {
            exceptionDetail = [NSString stringWithFormat:@"error:%@ \nstackInfo:%@ \nline:%@ \ncolumn:%@",info,stackInfo,lineNumberInfo,columnNumberInfo];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.contextHandler.exceptionHandler) {
                self.contextHandler.exceptionHandler(info,exceptionDetail);
            }
        });
    }];
}

- (void)injectionMethodWithManagerName:(nonnull NSString *)managerName methodName:(nonnull NSString *)methodName implementation:(nonnull ROCBridgeMethodImplementation)implementation {
    
    
}

- (NSDictionary * _Nullable)invokeMethodWithManagerName:(nonnull NSString *)managerName methodName:(nonnull NSString *)methodName arguments:(nonnull NSArray *)arguments { 
    return nil;
}

@end
