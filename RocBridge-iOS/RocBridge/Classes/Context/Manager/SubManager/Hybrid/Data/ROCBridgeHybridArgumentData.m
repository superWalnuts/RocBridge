//
//  ROCBridgeHybridArgumentData.m
//  RocBridge
//
//  Created by RocYang on 2021/9/21.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import "ROCBridgeHybridArgumentData.h"
@interface ROCBridgeHybridArgumentData()
@property (nonatomic) NSString *type;
@property (nonatomic) ROCArgumentNullability nullability;
@property (nonatomic) BOOL unused;
@property (nonatomic) NSString *name;
@end

@implementation ROCBridgeHybridArgumentData

- (instancetype)initWith:(NSString *)type
             nullability:(ROCArgumentNullability)nullability
                  unused:(BOOL)unused
                    name:(NSString *)name
{
    self = [super init];
    if (self) {
        _type = [self.type copy];
        _nullability = nullability;
        _unused = unused;
        _name = name;
    }
    return self;
}

@end
