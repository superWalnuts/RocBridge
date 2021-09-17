//
//  ROCBridgeHybridModuleData.m
//  RocBridge
//
//  Created by RocYang on 2021/9/12.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import "ROCBridgeHybridModuleData.h"
#import "ROCBridgeHybridMethodData.h"
#import <objc/runtime.h>

@interface ROCBridgeHybridModuleData()
@property (nonatomic) ROCBridgeHybridRegister *hybridRegister;
@property (nonatomic) ROCBridgeEventManager *eventManager;
@property (nonatomic) NSDictionary<NSString *, ROCBridgeHybridMethodData *> *methodBook;
@property (nonatomic) NSString *moduleName;

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
    if (!self.hybridRegister.moduleClass) {
        NSString *errorMsg = [NSString stringWithFormat:@"ModuleClass is undefind!"];
        NSLog(@"%@", errorMsg);
        return;
    }
    [self setUpModuleName];
    [self setUpMethodBook];
}

- (void)setUpModuleName
{
    NSString *methodString = @"moduleName";
    SEL selector = NSSelectorFromString(methodString);
    if (![self.hybridRegister.moduleClass respondsToSelector:selector]) {
        NSString *errorMsg = [NSString stringWithFormat:@"Function is undefind! ClassName is %@, MethodName is %@", NSStringFromClass(self.hybridRegister.moduleClass), methodString];
        NSLog(@"%@", errorMsg);
        return;
    }
    
    IMP imp = [self.hybridRegister.moduleClass methodForSelector:selector];
    NSString* (*func)(id, SEL) = (void *)imp;
    NSString *moduleName = func(self.hybridRegister.moduleClass, selector);
    
    if (![moduleName isKindOfClass:NSString.class]) {
        NSString *errorMsg = [NSString stringWithFormat:@"ModuleName return value must be a NSString. ClassName is %@.", NSStringFromClass(self.hybridRegister.moduleClass)];
        NSLog(@"%@", errorMsg);
        return;
    }
    
    self.moduleName = moduleName;
}

- (void)setUpMethodBook
{
    NSMutableDictionary *methodBook = [NSMutableDictionary new];
    
    unsigned int methodCount;
    Class cls = self.hybridRegister.moduleClass;
    while (cls && cls != [NSObject class] && cls != [NSProxy class]) {
        Method *methods = class_copyMethodList(object_getClass(cls), &methodCount);
        for (unsigned int i = 0; i < methodCount; i++) {
            Method method = methods[i];
            SEL selector = method_getName(method);
            if ([NSStringFromSelector(selector) hasPrefix:@"__roc_bridge_export__"]) {
                IMP imp = method_getImplementation(method);
                NSDictionary *methodInfo = ((NSDictionary *(*)(id, SEL)) imp)(self.hybridRegister.moduleClass, selector);
                if (!methodInfo) {
                    continue;
                }
                
                ROCBridgeHybridMethodData *methodData = [[ROCBridgeHybridMethodData alloc] initWithMethodInfo:methodInfo hybridRegister:self.hybridRegister];
                
                [methodBook setObject:methodData forKey:methodData.hybridMethodName];
                
            }
        }
        
        free(methods);
        cls = class_getSuperclass(cls);
    }
    
    self.methodBook = methodBook;
}

@end
