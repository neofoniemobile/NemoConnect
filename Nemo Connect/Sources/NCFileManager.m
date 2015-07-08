//
//  NCFileManager.m
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

#import "NCFileManager.h"

@implementation NCFileManager

+ (uint64_t)totalBytesForFileWithPath:(NSString *)path
{
    return [[[NSFileManager defaultManager] attributesOfItemAtPath:path error:NULL] fileSize];
}

+ (NSString *)uniqueNameWithNumberOfCharacters:(NSUInteger)characters
{
    NSString *string = [[[[NSUUID UUID] UUIDString] substringToIndex:characters] lowercaseString];

    return string;
}

+ (NSURL *)saveDataToTemporaryFolder:(NSData *)data name:(NSString *)uniqueFileName
{
    NSParameterAssert(data);
    NSParameterAssert(uniqueFileName);

    NSURL *fullPath = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:uniqueFileName]];

    [data writeToFile:fullPath.path atomically:NO];

    return fullPath;
}

+ (NSError *)removeDataFileFromTemporaryFolderWithName:(NSString *)name
{
    NSError *error;

    NSURL *fullPath = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:name]];

    [[NSFileManager defaultManager] removeItemAtURL:fullPath error:&error];

    return error;
}

@end
