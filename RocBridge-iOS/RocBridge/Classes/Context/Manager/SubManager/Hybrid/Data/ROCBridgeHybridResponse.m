//
//  ROCBridgeHybridResponse.m
//  RocBridge
//
//  Created by RocYang on 2021/7/1.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import "ROCBridgeHybridResponse.h"

@implementation ROCBridgeHybridResponse

- (NSDictionary *)toDic
{
    return @{@"success": @(self.success), @"code": @(self.code), @"data": self.data?:@{}};
}

- (void)setUpWithDic:(NSDictionary *)data
{
    if (!data) {
        return;
    }
    
    self.success = [data[@"success"] boolValue];
    self.code = [data[@"code"] integerValue];
    self.data = data[@"data"];
}
@end
