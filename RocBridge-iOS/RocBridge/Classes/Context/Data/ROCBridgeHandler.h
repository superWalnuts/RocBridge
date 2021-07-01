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

typedef void(^ROCExceptionHandler)(NSString *exceptionInfo,NSString *detailInfo);
typedef void(^ROCInitCompleteHandler)(BOOL success);
typedef void(^ROCLogHandler)(ROCBridgeContextLog *log);

NS_ASSUME_NONNULL_BEGIN

@interface ROCBridgeHandler : NSObject

@property(nonatomic,copy) ROCExceptionHandler exceptionHandler;
@property(nonatomic,copy) ROCInitCompleteHandler initCompleteHandler;
@property(nonatomic,copy) ROCLogHandler logHandler;
@property(nonatomic,strong) NSArray<ROCBridgeEventHandler *> *eventHandlerArray;

@end

NS_ASSUME_NONNULL_END
