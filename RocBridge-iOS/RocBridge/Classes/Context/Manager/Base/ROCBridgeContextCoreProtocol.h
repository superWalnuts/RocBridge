//
//  ROCBridgeContextCoreProtocol.h
//  RocBridge
//
//  Created by RocYang on 2021/7/4.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSDictionary *_Nullable(^ROCBridgeMethodImplementation)(NSDictionary *invokeInfo, NSDictionary *data);

@protocol ROCBridgeContextCoreProtocol <NSObject>

- (NSDictionary * _Nullable)invokeMethodWithManagerName:(NSString *)managerName
                                   methodName:(NSString *)methodName
                                    arguments:(NSArray *)arguments;
 
- (void)injectionMethodWithManagerName:(NSString *)managerName
                            methodName:(NSString *)methodName
                        implementation:(ROCBridgeMethodImplementation)implementation;


@end

NS_ASSUME_NONNULL_END
