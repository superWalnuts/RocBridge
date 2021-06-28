//
//  ROCBridgeConfig.h
//  RocBridge
//
//  Created by RocYang on 2021/6/28.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ROCBridgeHybridRegisterData.h"

NS_ASSUME_NONNULL_BEGIN

@interface ROCBridgeConfig : NSObject

/// Name of the JSContext. Exposed when remote debugging the context.
@property(nonatomic, strong) NSString *name;

@property(nonatomic, strong) NSArray<ROCBridgeHybridRegisterData *> *hybridArray;

@property(nonatomic, strong) NSDictionary *mainParams;

@property(nonatomic, weak) UIViewController *viewController;


@end

NS_ASSUME_NONNULL_END
