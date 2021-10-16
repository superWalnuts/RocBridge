//
//  ROCBridgeJSInterfaceManager.h
//  RocBridge
//
//  Created by RocYang on 2021/10/16.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROCBridgeBaseManager.h"
#import "ROCBridgeJSInterfaceRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface ROCBridgeJSInterfaceManager : ROCBridgeBaseManager

- (void)invokeJSAsyncInterface:(ROCBridgeJSInterfaceRequest *)interfaceRequest;

@end

NS_ASSUME_NONNULL_END
