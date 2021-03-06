//
//  ROCBridgeHandler.h
//  RocBridge
//
//  Created by RocYang on 2021/7/1.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ROCBridgeEventHandler.h"
#import "ROCBridgeContextLog.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ROCExceptionHandler)(NSString *exceptionInfo,NSString *detailInfo);
typedef void(^ROCInitCompleteHandler)(BOOL success);
typedef void(^ROCLogHandler)(ROCBridgeContextLog *log);

@interface ROCBridgeHandler : NSObject

@property(nonatomic) ROCExceptionHandler exceptionHandler;
@property(nonatomic) ROCInitCompleteHandler initCompleteHandler;
@property(nonatomic) ROCLogHandler logHandler;
@property(nonatomic) NSArray<ROCBridgeEventHandler *> *eventHandlerArray;

@end

NS_ASSUME_NONNULL_END
