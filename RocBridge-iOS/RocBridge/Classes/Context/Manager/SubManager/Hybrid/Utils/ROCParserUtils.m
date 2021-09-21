//
//  ROCParserUtils.m
//  RocBridge
//
//  Created by RocYang on 2021/9/21.
//  Copyright © 2021 RocYang. All rights reserved.
//  From ReactNative RCTParserUtils Copy.
//

#import "ROCParserUtils.h"

@implementation ROCParserUtils

BOOL ROCReadChar(const char **input, char c)
{
    if (**input == c) {
        (*input)++;
        return YES;
    }
    return NO;
}

BOOL ROCReadString(const char **input, const char *string)
{
    int i;
    for (i = 0; string[i] != 0; i++) {
        if (string[i] != (*input)[i]) {
            return NO;
        }
    }
    *input += i;
    return YES;
}

void ROCSkipWhitespace(const char **input)
{
    while (isspace(**input)) {
        (*input)++;
    }
}

static BOOL ROCIsIdentifierHead(const char c)
{
    return isalpha(c) || c == '_';
}

static BOOL ROCIsIdentifierTail(const char c)
{
    return isalnum(c) || c == '_';
}

BOOL ROCParseArgumentIdentifier(const char **input, NSString **string)
{
    const char *start = *input;

    do {
        if (!ROCIsIdentifierHead(**input)) {
            return NO;
        }
        (*input)++;

        while (ROCIsIdentifierTail(**input)) {
            (*input)++;
        }
    } while (ROCReadString(input, "::"));

    if (string) {
        *string = [[NSString alloc] initWithBytes:start length:(NSInteger)(*input - start) encoding:NSASCIIStringEncoding];
    }
    return YES;
}

BOOL ROCParseSelectorIdentifier(const char **input, NSString **string)
{
    const char *start = *input;
    if (!ROCIsIdentifierHead(**input)) {
        return NO;
    }
    (*input)++;
    while (ROCIsIdentifierTail(**input)) {
        (*input)++;
    }
    if (string) {
        *string = [[NSString alloc] initWithBytes:start length:(NSInteger)(*input - start) encoding:NSASCIIStringEncoding];
    }
    return YES;
}

static BOOL ROCIsCollectionType(NSString *type)
{
    static NSSet *collectionTypes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        collectionTypes = [[NSSet alloc] initWithObjects:@"NSArray", @"NSSet", @"NSDictionary", nil];
    });
    return [collectionTypes containsObject:type];
}

NSString *ROCParseType(const char **input)
{
    NSString *type;
    ROCParseArgumentIdentifier(input, &type);
    ROCSkipWhitespace(input);
    if (ROCReadChar(input, '<')) {
        ROCSkipWhitespace(input);
        NSString *subtype = ROCParseType(input);
        if (ROCIsCollectionType(type)) {
            if ([type isEqualToString:@"NSDictionary"]) {
                ROCSkipWhitespace(input);
                ROCReadChar(input, ',');
                ROCSkipWhitespace(input);
                subtype = ROCParseType(input);
            }
            if (![subtype isEqualToString:@"id"]) {
                type = [type stringByReplacingCharactersInRange:(NSRange){0, 2 /* "NS" */} withString:subtype];
            }
        } else {
            
        }
        ROCSkipWhitespace(input);
        ROCReadChar(input, '>');
    }
    ROCSkipWhitespace(input);
    if (!ROCReadChar(input, '*')) {
        ROCReadChar(input, '&');
    }
    return type;
}

@end
