//
//  ROCBridgeConfig.h
//  RocBridge
//
//  Created by RocYang on 2021/6/28.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ROCBridgeHybridRegister.h"
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface ROCBridgeConfig : NSObject

/// Name of the JSContext. Exposed when remote debugging the context.
@property(nonatomic, strong) NSString *name;

/// Registration of Hybrid Modules.
@property(nonatomic, strong) NSArray<ROCBridgeHybridRegister *> *hybridModules;

/// Pass it into the main method when the environment is initialized.
@property(nonatomic, strong) NSDictionary *mainParameter;

/// Current viewController.
@property(nonatomic, weak) UIViewController *viewController;

@property(nonatomic, strong) JSVirtualMachine *jsVirtualMachine;

@end

NS_ASSUME_NONNULL_END
