//
//  ROCBridgeHybridMethodData.m
//  RocBridge
//
//  Created by RocYang on 2021/9/12.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import "ROCBridgeHybridMethodData.h"
#import "ROCBridgeHybridArgumentData.h"
#import "ROCParserUtils.h"
#import "ROCBridgeHybridArgumentData.h"

@interface ROCBridgeHybridMethodData()
@property (nonatomic) ROCBridgeHybridRegister *hybridRegister;

@property (nonatomic) NSString *originalMethodName;
@property (nonatomic) NSString *hybridMethodName;
@property (nonatomic) BOOL isSync;
@property (nonatomic) BOOL needAdditionInfo;

@property (nonatomic) SEL selector;
@property (nonatomic) IMP funcImp;
@property (nonatomic) NSArray<ROCBridgeHybridArgumentData *> *arguments;
@end

@implementation ROCBridgeHybridMethodData

- (instancetype)initWithMethodInfo:(NSDictionary *)methodInfo hybridRegister:(ROCBridgeHybridRegister *)hybridRegister
{
    self = [super init];
    if (self) {
        [self setUpMethodData:methodInfo];
    }
    return self;
}

- (void)setUpMethodData:(NSDictionary *)methodInfo
{
    if (!methodInfo) {
        return;
    }
    
    self.hybridMethodName = methodInfo[@"name"];
    self.isSync = methodInfo[@"isSync"];
    self.originalMethodName = methodInfo[@"method"];
    
    if (self.originalMethodName.length == 0) {
        NSString *errorMsg = [NSString stringWithFormat:@"MethodName is Null. ClassName is %@.", NSStringFromClass(self.hybridRegister.moduleClass)];
        NSLog(@"%@", errorMsg);
        return;
    }
    
    if (self.hybridMethodName.length == 0) {
        self.hybridMethodName = [self analysisHybridMethodNameWithOriginalMethodName:self.originalMethodName];
    }
    
    [self updateArgumentsAndSelectorWithOriginalMethodName:self.originalMethodName];
}

- (IMP)getMethodIMP
{
    if (self.funcImp) {
        return self.funcImp;
    }
    
    if (!self.selector) {
        return nil;
    }
    
    if (![self.hybridRegister.moduleClass instancesRespondToSelector:self.selector]) {
        return nil;
    }
    
    IMP imp = [self.hybridRegister.moduleClass instanceMethodForSelector:self.selector];
    self.funcImp = imp;
    return imp;
}

- (BOOL)checkArguments
{
    return YES;
}

- (NSString *)analysisHybridMethodNameWithOriginalMethodName:(NSString *)originalMethodName
{
    NSString *hybridMethodName = nil;
    NSRange colonRange = [originalMethodName rangeOfString:@":"];
    if (colonRange.location == NSNotFound) {
        NSString *errorMsg = [NSString stringWithFormat:@"MethodName is illegality. MethodName is %@, ClassName is %@.", originalMethodName, NSStringFromClass(self.hybridRegister.moduleClass)];
        NSLog(@"%@", errorMsg);
        return nil;
    }
    
    hybridMethodName = [originalMethodName substringToIndex:colonRange.location];
    hybridMethodName = [hybridMethodName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (hybridMethodName.length == 0) {
        NSString *errorMsg = [NSString stringWithFormat:@"MethodName is illegality. MethodName is %@, ClassName is %@.", originalMethodName, NSStringFromClass(self.hybridRegister.moduleClass)];
        NSLog(@"%@", errorMsg);
        return nil;
    }
    
    return hybridMethodName;
}

- (void)updateArgumentsAndSelectorWithOriginalMethodName:(NSString *)originalMethodName
{
    NSArray<ROCBridgeHybridArgumentData *> *arguments;
    self.selector = ROCParseMethodOriginalName(originalMethodName, arguments);
    self.arguments = arguments;
    
    if (!self.selector) {
        NSString *errorMsg = [NSString stringWithFormat:@"Selector is illegality. MethodName is %@, ClassName is %@.", originalMethodName, NSStringFromClass(self.hybridRegister.moduleClass)];
        NSLog(@"%@", errorMsg);
        return;
    }
    
    if (![self checkArguments]) {
        NSString *errorMsg = [NSString stringWithFormat:@"Arguments is illegality. MethodName is %@, ClassName is %@.", originalMethodName, NSStringFromClass(self.hybridRegister.moduleClass)];
               NSLog(@"%@", errorMsg);
        self.selector = nil;
        return;
    }
}

SEL ROCParseMethodOriginalName(NSString *originalMethodName, NSArray<ROCBridgeHybridArgumentData *> **arguments)
{
    const char *input = originalMethodName.UTF8String;
    ROCSkipWhitespace(&input);
    
    NSMutableArray *args = [NSMutableArray new];;
    NSMutableString *selector = [NSMutableString new];
    
    while (ROCParseSelectorPart(&input, selector)) {
        
        NSString *type = nil;
        ROCArgumentNullability nullability = ROCArgumentNullabilityUnspecified;
        BOOL unused = NO;
        NSString *name = nil;
        
        if (ROCReadChar(&input, '(')) {
            ROCSkipWhitespace(&input);
            unused = ROCParseUnused(&input);
            
            ROCSkipWhitespace(&input);
            nullability = ROCParseNullability(&input);
            
            ROCSkipWhitespace(&input);
            type = ROCParseType(&input);
            
            if (nullability == ROCArgumentNullabilityUnspecified) {
                nullability = ROCParseNullabilityPostfix(&input);
            }
            
            ROCSkipWhitespace(&input);
            ROCReadChar(&input, ')');
            ROCSkipWhitespace(&input);
        } else {
            type = id;
            nullability = ROCArgumentNullable;
            unused = NO;
        }
        
        ROCParseArgumentIdentifier(&input, &name);
        ROCSkipWhitespace(&input);
        
        ROCBridgeHybridArgumentData *argumentData = [[ROCBridgeHybridArgumentData alloc] initWith:type nullability:nullability unused:unused name:name];
        [args addObject:argumentData];
    }
    
    *arguments = [args copy];
    
    return NSSelectorFromString(selector);
}

static BOOL ROCParseSelectorPart(const char **input, NSMutableString *selector) {
    NSString *selectorPart;
    if (ROCParseArgumentIdentifier(input, &selectorPart)) {
        [selector appendString:selectorPart];
    }
    
    ROCSkipWhitespace(input);
    
    if (ROCReadChar(input, ':')) {
        [selector appendString:@":"];
        ROCSkipWhitespace(input);
        return YES;
    }
    
    return NO;
}

static BOOL ROCParseUnused(const char **input) {
    return ROCReadString(input, "__unused") || ROCReadString(input, "__attribute__((unused))");
}

static ROCArgumentNullability ROCParseNullabilityPostfix(const char **input) {
    if (ROCReadString(input, "_Nullable")) {
        return ROCArgumentNullable;
    } else if (ROCReadString(input, "_Nonnull")) {
        return ROCArgumentNonnullable;
    }
    return ROCArgumentNullabilityUnspecified;
}

static ROCArgumentNullability ROCParseNullability(const char **input) {
    if (ROCReadString(input, "nullable")) {
        return ROCArgumentNullable;
    } else if (ROCReadString(input, "nonnull")) {
        return ROCArgumentNonnullable;
    }
    return ROCArgumentNullabilityUnspecified;
}

- (NSDictionary *)coreInfo
{
    return @{@"isSync": @(self.isSync)};
}
@end
