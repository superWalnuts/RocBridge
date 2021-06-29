//
//  ROCBridgeHybridModuleRegister.h
//  RocBridge
//
//  Created by RocYang on 2021/6/29.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROCBridgeBaseHybridModule.h"

NS_ASSUME_NONNULL_BEGIN

@interface ROCBridgeHybridModuleRegister : NSObject

@property(nonatomic) Class moduleClass;

@property(nonatomic) ROCBridgeBaseHybridModule *moduleInstance;

@end

NS_ASSUME_NONNULL_END
