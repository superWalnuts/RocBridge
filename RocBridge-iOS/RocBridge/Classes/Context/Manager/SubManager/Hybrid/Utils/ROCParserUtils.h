//
//  ROCParserUtils.h
//  RocBridge
//
//  Created by RocYang on 2021/9/21.
//  Copyright © 2021 RocYang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ROCArgumentNullability)
{
    ROCArgumentNullabilityUnspecified,
    ROCArgumentNullable,
    ROCArgumentNonnullable
};

@interface ROCParserUtils : NSObject

BOOL ROCReadChar(const char **input, char c);

BOOL ROCReadString(const char **input, const char *string);

void ROCSkipWhitespace(const char **input);

static BOOL ROCIsIdentifierHead(const char c);

static BOOL ROCIsIdentifierTail(const char c);

BOOL ROCParseArgumentIdentifier(const char **input, NSString **string);

BOOL ROCParseSelectorIdentifier(const char **input, NSString **string);

static BOOL ROCIsCollectionType(NSString *type);

NSString *ROCParseType(const char **input);

@end

