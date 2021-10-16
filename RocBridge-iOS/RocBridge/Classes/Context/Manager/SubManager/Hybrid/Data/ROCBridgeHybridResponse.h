//
//  ROCBridgeHybridResponse.h
//  RocBridge
//
//  Created by RocYang on 2021/7/1.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ROCBridgeResponseCode) {
    ROCBridgeResponseError = -1,
    ROCBridgeResponseSuccess = 0,
    ROCBridgeResponseException = 1,
    ROCBridgeResponseMethodInexistence = 2,
    ROCBridgeResponseEventUnRegister = 3,
};

NS_ASSUME_NONNULL_BEGIN

@interface ROCBridgeHybridResponse : NSObject
@property (nonatomic) BOOL success;
@property (nonatomic) ROCBridgeResponseCode code;
@property (nonatomic) NSDictionary *data;

- (NSDictionary *)toDic;
- (void)setUpWithDic:(NSDictionary *)data;
@end

typedef void(^ROCBridgeResponseCallback)(ROCBridgeHybridResponse *response);

NS_ASSUME_NONNULL_END
