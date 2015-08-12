//
//  NCFileDescription.m
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

#import "NCFileDescription.h"

@implementation NCFileDescription

+ (instancetype)fileDescriptionWithMimeType:(NSString *)mimeType parameter:(NSString *)parameter filename:(NSString *)filename fileContents:(NSData *)fileContents
{
    return [[self alloc] initWithMimeType:mimeType parameter:parameter filename:filename fileContents:fileContents];
}

- (instancetype)initWithMimeType:(NSString *)mimeType parameter:(NSString *)parameter filename:(NSString *)filename fileContents:(NSData *)fileContents
{
    self = [super init];
    if (self)
    {
        _mimeType = [mimeType copy];
        _parameter = [parameter copy];
        _filename = [filename copy];
        _fileContents = fileContents;
    }

    return self;
}

- (BOOL)isEqual:(id)other
{
    if (other == self)
    {
        return YES;
    }
    if(![other isKindOfClass:[self class]])
    {
        return NO;
    }

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCDFAInspection"
    NCFileDescription *otherFileDescription = (NCFileDescription *)other;
#pragma clang diagnostic pop

    return [self.mimeType isEqualToString:otherFileDescription.mimeType]
            && [self.filename isEqualToString:otherFileDescription.filename]
            && [self.parameter isEqualToString:otherFileDescription.parameter]
            && [self.fileContents isEqualToData:self.fileContents];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end
