//
//  ROCBridgeHybridArgumentData.h
//  RocBridge
//
//  Created by RocYang on 2021/9/21.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROCParserUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface ROCBridgeHybridArgumentData : NSObject

@property (nonatomic, readonly) NSString *type;
@property (nonatomic, readonly) ROCArgumentNullability nullability;
@property (nonatomic, readonly) BOOL unused;
@property (nonatomic, readonly) NSString *name;

- (instancetype)initWith:(NSString *)type
             nullability:(ROCArgumentNullability)nullability
                  unused:(BOOL)unused
                    name:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
