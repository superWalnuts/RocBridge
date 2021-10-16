//
//  ROCBridgeHybridManager.h
//  RocBridge
//
//  Created by RocYang on 2021/9/12.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import "ROCBridgeBaseManager.h"
#import "ROCBridgeHybridRegister.h"
#import "ROCBridgeHybridAdditionInfo.h"
#import "ROCBridgeEventManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ROCBridgeHybridManager : ROCBridgeBaseManager

- (void)setUpManagerWith:(NSArray<ROCBridgeHybridRegister *> *)hybridRegisterArray
            eventManager:(ROCBridgeEventManager *)eventManager
             additionInfo:(ROCBridgeHybridAdditionInfo *)additionInfo;

@end

NS_ASSUME_NONNULL_END
