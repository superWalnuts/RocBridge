//
//  ROCBridgeBaseHybridModule.h
//  RocBridge
//
//  Created by RocYang on 2021/6/30.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ROCBridgeBaseHybridModule : NSObject

/**
 字符串拼接
 */
#define ROC_CONCAT2(A, B) A##B
#define ROC_CONCAT(A, B) RCT_CONCAT2(A, B)

/**
 设置 ModuleName
 */
#define ROC_MODULE_NAME(js_name)          \
+(NSString *)moduleName                   \
{                                         \
  return @ #js_name;                      \
}                                         \

/**
 注册方法，默认方法名导出
 */
#define ROC_EXPORT_METHOD(method) RCT_REMAP_METHOD(, method)
#define ROC_EXPORT_SYNC_METHOD(method) ROC_REMAP_SYNC_METHOD(, method)


/**
 注册异步方法
 */
#define ROC_REMAP_METHOD(js_name, method)       \
_ROC_EXTERN_REMAP_METHOD(js_name, method, NO)   \
-(void)method;

/**
 注册同步方法
 */
#define ROC_REMAP_SYNC_METHOD(js_name, method)       \
_ROC_EXTERN_REMAP_METHOD(js_name, method, YES)       \
-(ROCBridgeHybridResponse *)method;

/**
 实现方法信息函数
 */
#define _ROC_EXTERN_REMAP_METHOD(js_name, method, isSync)                                                  \
+(NSDictionary *)ROC_CONCAT(__roc_bridge_export__, ROC_CONCAT(js_name, ROC_CONCAT(__LINE__, __COUNTER__))) \
{                                                                                                          \
    return @{@"name": @#js_name?:@"", @"method": @#method?:@"", @"isSync":@(isSync)};                      \
}

/**
 生命支持的Event
 */
#define SUPPER_EVENT_NAMES(names...)                                                  \
+ (NSArray *)supperEventNames \
{                                                                                                          \
    return @[@#names];                      \
}
@end

NS_ASSUME_NONNULL_END
