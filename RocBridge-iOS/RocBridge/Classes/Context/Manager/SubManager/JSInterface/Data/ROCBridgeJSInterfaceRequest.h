//
//  ROCBridgeJSInterfaceRequest.h
//  RocBridge
//
//  Created by RocYang on 2021/10/16.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROCBridgeHybridResponse.h"
NS_ASSUME_NONNULL_BEGIN

@interface ROCBridgeJSInterfaceRequest : NSObject

@property (nonatomic) NSString *className;
@property (nonatomic) NSString *interfaceName;
@property (nonatomic) NSDictionary *param;
@property (nonatomic) ROCBridgeResponseCallback responseCallback;

@end

NS_ASSUME_NONNULL_END
