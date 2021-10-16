//
//  ViewController.m
//  RocBridgeExample
//
//  Created by RocYang on 2021/6/23.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import "ViewController.h"
#import <RocBridge/RocBridge.h>
@interface ViewController ()
@property (nonatomic) ROCBridgeContext *context;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSData *jsData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://192.168.1.105:60105/bundle.js"]];
    NSString *jsStr = [[NSString alloc] initWithData:jsData encoding:NSUTF8StringEncoding];
    
    ROCBridgeConfig *config = [ROCBridgeConfig new];
    config.name = @"test";
    
    ROCBridgeHybridAdditionInfo *additionInfo = [ROCBridgeHybridAdditionInfo new];
    additionInfo.viewController = self;
    
    config.additionInfo = additionInfo;
    
    ROCBridgeHandler *handler = [ROCBridgeHandler new];
    handler.exceptionHandler = ^(NSString * _Nonnull exceptionInfo, NSString * _Nonnull detailInfo) {
        
    };
    
    handler.initCompleteHandler = ^(BOOL success) {
        
    };

    self.context = [[ROCBridgeContext alloc] initContextWithJSString:jsStr contextConfig:config contextHandler:handler];
}


@end
