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
@property (nonatomic) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, ROCBridgeMethodImplementation> *> *methodBook;
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
        _methodBook = [NSMutableDictionary new];
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
    [self setUpMethodImplementation];
    
    [self.jsContext evaluateScript:self.jsString];
    JSValue *window = self.jsContext[@"window"];
    JSValue *rocBridgeContext = window[@"rocBridgeContext"];
    JSValue *test = rocBridgeContext[@"test"];
    NSString *str = [test toString];
    
}

- (void)setUpMethodImplementation
{
    JSValue *window = self.jsContext[@"window"];
    __weak typeof (self) weakSelf = self;
    window[@"invokeNativeMethod"] = ^NSDictionary* (NSDictionary *nativeMethodInfo, NSDictionary *params) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        NSString *managerName = nativeMethodInfo[@"className"];
        NSString *methodName = nativeMethodInfo[@"methodName"];
        return [strongSelf invokeNativeMethodWithManagerName:managerName methodName:methodName params:params];
    };

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

- (NSDictionary *)invokeNativeMethodWithManagerName:(nonnull NSString *)managerName methodName:(nonnull NSString *)methodName params:(NSDictionary *)params
{
    if (managerName.length == 0 || methodName.length == 0) {
        return nil;
    }
    
    NSMutableDictionary *managerInfo = [self.methodBook objectForKey:managerName];

    if (!managerInfo) {
        return nil;
    }
    
    ROCBridgeMethodImplementation implementation = [managerInfo objectForKey:methodName];
    
    if (!implementation) {
        return nil;
    }
    
    NSDictionary *result = implementation(params);
    
    return result;
}

- (void)injectionMethodWithManagerName:(nonnull NSString *)managerName methodName:(nonnull NSString *)methodName implementation:(nonnull ROCBridgeMethodImplementation)implementation {
    if (managerName.length == 0 || methodName.length == 0 || !implementation) {
        return;
    }
    
    NSMutableDictionary *managerInfo = [self.methodBook objectForKey:managerName];
    if (!managerInfo) {
        managerInfo = [NSMutableDictionary new];
    }
    
    [managerInfo setObject:implementation forKey:methodName];
    [self.methodBook setObject:managerInfo forKey:managerName];
}

- (NSDictionary * _Nullable)invokeJSMethodWithManagerName:(nonnull NSString *)managerName methodName:(nonnull NSString *)methodName params:(nonnull NSDictionary *)params {
    
    if (managerName.length == 0) {
        return nil;
    }
    
    if (methodName.length == 0) {
        return nil;
    }
    
    if (!params) {
        params = @{};
    }
    
    JSValue *window = self.jsContext[@"window"];
    
    if (!window) {
        return nil;
    }
    
    JSValue *jsFunction = window[@"invokeJSMethod"];
    
    if (!jsFunction) {
        return nil;
    }
    
    NSMutableArray *arguments = [NSMutableArray new];
    [arguments addObject:@{@"className": managerName, @"methodName": methodName}];
    if (params) {
        [arguments addObject:params];
    }
    
    JSValue *result = [jsFunction callWithArguments:arguments.copy];
    
    if (!result) {
        return nil;
    }
    
    if ([result isUndefined] || [result isNull]) {
        return nil;
    }
    
    if ([result isObject]) {
        NSDictionary *dic = [result toDictionary];
        if ([dic isKindOfClass:NSDictionary.class]) {
            return dic;
        }
    }
    
    NSAssert(NO, @"The return value of invokeJSMethod is not a dictionary！");
    
    return nil;
}

@end
